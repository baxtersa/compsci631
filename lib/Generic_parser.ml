open MParser
open MParser_RE
open Tokens

type 'a parser = ('a, unit) MParser.t

let id : string parser = regexp (make_regexp "[A-Za-z_][A-Za-z_0-9_']*") <<< spaces

let rev_fold_left f xs = match List.rev xs with
  | [] -> raise (Failure "expected at least one element (internal error)")
  | x :: xs -> List.fold_left f x xs

let from_string exp (str : string) = match parse_string exp str () with
  | Success exp -> exp
  | Failed (msg, _) ->
    Printf.eprintf "%s\n%!" msg; failwith msg

let from_file exp (fname : string) =
  let chan = open_in fname in
  match parse_channel exp chan () with
  | Success exp -> exp
  | Failed (msg, _) ->
    Printf.eprintf "%s\n%!" msg;
    failwith msg
