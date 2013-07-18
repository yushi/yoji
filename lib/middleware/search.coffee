exports = module.exports = (root)->
  return SearchMiddleware = (req, res, next)->
    if 'GET' != req.method && 'HEAD' != req.method
      return next()
    if not req.query.kw
      return next()

    console.log req.query
    res.setHeader 'Content-Type', 'text/plain'
    res.write('this is search middleware')
    res.end()
