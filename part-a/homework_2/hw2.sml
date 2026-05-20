fun same_string(s1 : string, s2 : string) =
    s1 = s2

datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 

type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove


fun all_except_option (target, lst) =
   let
      fun exclude_match (_, []) = NONE
        | exclude_match (acc, head::tail) =
            if same_string(head, target)
            then SOME(acc @ tail)
            else exclude_match(acc @ [head], tail)
   in
      exclude_match([], lst)
   end;


fun get_substitutions1 ([], _) = []
  | get_substitutions1 (head::tail, target) =
      case all_except_option(target, head) of
            NONE => get_substitutions1(tail, target)
          | SOME(data) => data@get_substitutions1(tail, target);


fun get_substitutions2(lst, target) =
   let
      fun substitute(acc, []) = acc
        | substitute(acc, head::tail) =
            case all_except_option(target, head) of
               NONE => substitute(acc, tail)
            |  SOME(data) => substitute(acc@data, tail)
   in
      substitute([], lst)
   end;


fun similar_names(names: string list list, full_name: {first:string, middle:string, last:string}) =
   let
      val {first=first, middle=middle, last=last} = full_name
      val filtered_names = get_substitutions1(names, first)

      fun build_name_variants [] = []
        | build_name_variants (head::tail) = 
            {first=head, middle=middle, last=last}::build_name_variants(tail)
   in
      full_name::build_name_variants(filtered_names)
   end;


fun card_color (Spades, _) = Black
  | card_color (Clubs, _) = Black
  | card_color (_, _) = Red;


fun card_value (_, Ace) = 11
  | card_value (_, Num(value)) = value
  | card_value (_, _) = 10;


fun remove_card ([], _, exc) = raise exc
  | remove_card (head::tail, card, exc) =
      if head = card
      then tail
      else head::remove_card(tail, card, exc);


fun all_same_color ([]) = true
  | all_same_color (_::[]) = true
  | all_same_color (head::neck::rest) =
      if card_color(head) <> card_color(neck)
      then false
      else all_same_color(neck::rest);


fun sum_cards (cards) =
   let
      fun sum(acc, []) = acc
        | sum(acc, head::tail) = sum(acc+card_value(head), tail)
   in
      sum(0, cards)
   end;


fun score (cards, goal) =
   let
      val sum = sum_cards(cards)
      val preliminary_score = 
         if sum > goal
         then 3 * (sum-goal)
         else goal-sum
   in
      if all_same_color(cards)
      then preliminary_score div 2
      else preliminary_score
   end;


fun officiate (cards, movements, goal) =
   let
      fun move (held_cards, _, []) = score(held_cards, goal)
        | move (held_cards, card_list, move_head::move_tail) =
            case move_head of
               Draw => (case card_list of
                         [] => score(held_cards, goal)
                       | card_head::card_tail => if sum_cards(card_head::held_cards) > goal
                                                 then score(held_cards, goal)
                                                 else move(card_head::held_cards, card_tail, move_tail))
            | Discard(card) => move(remove_card(held_cards, card, IllegalMove), card_list, move_tail)

   in
      move([], cards, movements)
   end;
