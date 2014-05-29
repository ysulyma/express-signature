module.exports = signature

function signature(sig, options = {})
  options.failure ||= (req, res, next) ->
    next status: 401
  
  (req, res, next) ->
    if validate sig, req
      next!
    else
      options.failure req, res, next

function validate(cond, o, key)
  val = if key then o[key] else o
  switch typeof! cond
  | \Object
    for $key of cond
      return false unless validate cond[$key], val, $key
  | \Array
    for $cond in cond
      return false unless validate $cond, o, key
  | \RegExp
    return false unless val && val.match cond
  | \Function
    return false unless cond val, o, key
  | \String
    /* built-in types */
    switch cond
    | <[ double float ]>
      return false unless val
      o[key] = parse-float val
    | <[ int integer ]>
      return false unless val
      o[key] = parse-int val
    | <[ bool boolean ]>
      o[key] = (val && val != \false) || false
    | \string
      o[key] .= to-string!
  true
      
signature.validate = validate
signature.email = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
