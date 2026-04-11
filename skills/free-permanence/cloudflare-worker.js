// Cloudflare Worker - Dead Man's Switch Monitor
// Deploy to: https://workers.cloudflare.com/

// Bind a KV namespace called "HEARTBEATS" in worker settings

addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  const url = new URL(request.url)
  
  // Handle CORS
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type',
  }
  
  if (request.method === 'OPTIONS') {
    return new Response(null, { headers: corsHeaders })
  }
  
  // Heartbeat endpoint
  if (request.method === 'POST' && url.pathname === '/heartbeat') {
    try {
      const data = await request.json()
      const instanceId = data.instance_id || 'unknown'
      
      // Store heartbeat
      await HEARTBEATS.put(instanceId, JSON.stringify({
        timestamp: Date.now(),
        status: data.status || 'healthy',
        metrics: data.metrics || {},
        received_at: new Date().toISOString()
      }))
      
      console.log(`💓 Heartbeat received from ${instanceId}`)
      
      return new Response('OK', { 
        status: 200,
        headers: corsHeaders 
      })
    } catch (error) {
      console.error('Heartbeat error:', error)
      return new Response('Error', { 
        status: 400,
        headers: corsHeaders 
      })
    }
  }
  
  // Check status endpoint
  if (request.method === 'GET' && url.pathname === '/status') {
    try {
      const keys = await HEARTBEATS.list()
      const now = Date.now()
      const TIMEOUT = 30 * 60 * 1000 // 30 minutes
      
      const status = {
        monitor: 'active',
        timestamp: new Date().toISOString(),
        instances: []
      }
      
      for (const key of keys.keys) {
        const heartbeat = await HEARTBEATS.get(key.name)
        const data = JSON.parse(heartbeat)
        const age = now - data.timestamp
        const healthy = age < TIMEOUT
        
        status.instances.push({
          id: key.name,
          last_seen: data.received_at,
          age_seconds: Math.floor(age / 1000),
          status: healthy ? 'healthy' : 'timeout',
          metrics: data.metrics
        })
      }
      
      return new Response(JSON.stringify(status, null, 2), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    } catch (error) {
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }
  }
  
  // Health check endpoint
  if (request.method === 'GET' && url.pathname === '/health') {
    return new Response('Monitor Active', { 
      status: 200,
      headers: corsHeaders 
    })
  }
  
  return new Response('OpenClaw Dead Man\'s Switch Monitor', {
    headers: corsHeaders
  })
}
