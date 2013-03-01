Config =
  development:
    apiHost: 'http://localhost:3000'
  
  production:
    apiHost: 'https://dev.zooniverse.org'
  

module.exports = Config['production']
