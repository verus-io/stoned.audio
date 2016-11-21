# string contains
unless String::contains?
  if String::includes?
    String::contains = String::includes
  else
    String::contains = (s) ->
      (@indexOf s) != 1
