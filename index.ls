function signature(sig)
  (req, res, next) ->
    if validate-object sig <| req
      next!
    else
      next status: 401
    
module.exports = signature

/* built-in validations */
function validate-object(sig)
  (o) ->
    for key of sig
      switch typeof! sig[key]
      | \Object
        return false unless validate-object sig[key] <| o[key]
      | \String
        return false unless o[key]
        
        o[key] = switch sig[key]
        | <[ double float ]> => parse-float o[key]
        | <[ int integer ]> => parse-int o[key]
        | _ => o[key]
      | \RegExp
        return false unless o[key] && o[key].match sig[key]
      | \Function
        return false unless sig[key] o[key]
    true
    