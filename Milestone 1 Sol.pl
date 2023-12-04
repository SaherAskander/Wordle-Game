is_category(C):-
word(_,C).
categories(L):-
setof(C, is_category(C), L).
available_length(L):-
word(W,_),string_length(W,L).
pick_word(W,L,C):-
word(W,C),string_length(W,L).
correct_letters(_,[],[]).
correct_letters(L1,[H|T],[H|R]):- member(H,L1),correct_letters(L1,T,R).
correct_letters(L1,[H|T],L3):-   \+ member(H,L1) ,correct_letters(L1,T,L3).
correct_positions([],[],[]).
correct_positions([H|T1],[H|T2],[H|R]):- correct_positions(T1,T2,R).
correct_positions([H1|T1],[H2|T2],R):-   H1\=H2, correct_positions(T1,T2,R).

removeduplicate([],[]).
removeduplicate([H|T],[H|X]):- \+ member(H,T),removeduplicate(T,X).
removeduplicate([H|T],X):- member(H,T),removeduplicate(T,X).

gaming(Result,Counter):-
string_length(Result,Length),
write('Enter a word composed of  ' ), write(Length), write(' letters:'),nl,
read(Tested),nl,(
string_length(Tested,Length),gaming2(Result,Tested,Counter)
;
string_length(Tested,K),k\=Length,
nl,write('Word is not composed of  '), write(Length),write(' letters. Try again.'),nl,
write('Remaining Guesses are '),write(Counter),nl,
gaming(Result,Counter) ). 

gaming2(R,T,1):-
R\=T,write('You lost!'); (write('You Won!')).
gaming2(R,T,Counter):-
counter\=1,
string_chars(R,Rl),
string_chars(T,Tl), 
(R=T, write('You Won!'),nl
;
correct_letters(Tl,Rl,Cl1),
removeduplicate(Cl1,Cl0),
correct_positions(Tl,Rl,Cl2),nl,
write('Correct letters are: '),write(Cl0),nl,
write('Correct letters in correct positions are: '),write(Cl2),nl,C1 is Counter-1,
write('Remaining Guesses are '),write(C1),nl,
gaming(R,C1)
).


prowordlegame():-
kbphase(),
gameplayphase().

kbphase():-
write('Welcome to Pro-Wordle!'),nl,write('----------------------'),nl,kb().
kb():-
write('Please enter a word and its category on separate lines:'),nl,read(X),
(X=done ; 
        (read(Y),assert(word(X,Y)) ,kb())).   


avialablelengthincertaincategory(W,L,C):-
available_length(L),pick_word(W,L,C).


categoryexistence(C):-
write('Choose a category:'),nl,read(E),
(\+is_category(E),nl,write('This category does not exist.'),nl,categoryexistence(C);
is_category(E),E=C ).

lengthexistence(W,Length,C):-
write('Choose a length:'),nl,read(K),
(\+avialablelengthincertaincategory(_,K,C),nl,write('There are no words of this length.'),nl,lengthexistence(W,Length,C);
avialablelengthincertaincategory(W,K,C),Length=K).

gameplayphase():-
categories(L), write('The available categories are: '), write(L),nl,categoryexistence(C)
,lengthexistence(W,Length,C), Temp is Length+1, write('Game started. You have '),write(Temp),write(' guesses.') ,nl,gaming(W,Temp).