%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chatbot CSEN 403 Project  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%
%%  ASSUMPTIONS  %%
%%%%%%%%%%%%%%%%%%%

%% Stating Facts is answered by "Ok" not "ok.".
%% First letter in first word in answers is always Capital  Example : "You can have pizza for lunch".
%% We are using Approach 2 in test cases part 3 where "I told you before" is available as an answer for all Questions or stating facts.
%% This project file "prologProjectFinal.pl" doesn't contain the "info_food.pl" & "read_sentence.pl" Contents.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Inputs  %%%%       DONE   %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

readInputTillQuit:-
					write("Welcome to your personal assistant"),nl,
					write(">"),
					res(S),
					delete(S,'.',R),
					delete(R,'?',R1),
					readInputTillQuit2(R1,[],[]),!.
					
readInputTillQuit2(Q,PQ,PR):-
					once(test(Q)),
					once(getBreakfast(PQ,PR,B)),
					once(getLunch(PQ,PR,L)),
					once(getDinner(PQ,PR,D)),
					write("You had "),write(B),write(" for breakfast"),nl,
					write("You had "),write(L),write(" for lunch"),nl,
					write("You had "),write(D),write(" for dinner"),nl,
					write("Bye"),nl.
								
readInputTillQuit2(Q,PQ,PR):-
					isValid(Q),
					response(Q,PQ,PR,[R]),
					R\=[_|_],
					write(">"),
					ws([R]),nl,
					write(">"),
					res(S),
					delete(S,'?',S1),
					delete(S1,'.',S2),
					readInputTillQuit2(S2,[Q|PQ],[[R]|PR]).
		
readInputTillQuit2(Q,PQ,PR):-
					isValid(Q),
					response(Q,PQ,PR,[R]),
					R=[_|_],
					write(">"),
					ws(R),nl,
					write(">"),
					res(S),
					delete(S,'?',S1),
					delete(S1,'.',S2),
					readInputTillQuit2(S2,[Q|PQ],[R|PR]).
										
readInputTillQuit2(Q,PQ,PR):-
					isValid(Q),
					response(Q,PQ,PR,R),
					write(">"),
					ws(R),nl,
					write(">"),
					res(S),
					delete(S,'?',S1),
					delete(S1,'.',S2),
					readInputTillQuit2(S2,[Q|PQ],[R|PR]).

readInputTillQuit2(Q,PQ,PR):-
						\+isValid(Q),
						write(">"),
						write("I can not understand you"),nl,
						write(">"),
						res(S),
						delete(S,'?',S1),
						delete(S1,'.',S2),
						readInputTillQuit2(S2,PQ,PR).

test(Q):-  % test if user entered quit %
		Q=[quit].


getBreakfast([],[],"-").
getBreakfast([Hq|_],[Hr|_],F):-
								(Hq=[i,ate,F,for,breakfast];Hq=[can,i,have,F,for,breakfast]),
								(Hr=["Ok"];Hr=["You",can,have,F,for,breakfast]).								
getBreakfast([_|Tq],[_|Tr],F):-
								getBreakfast(Tq,Tr,F).

getLunch([],[],"-").
getLunch([Hq|_],[Hr|_],F):-
								(Hq=[i,ate,F,for,lunch];Hq=[can,i,have,F,for,lunch]),
								(Hr=["Ok"];Hr=["You",can,have,F,for,lunch]).								
getLunch([_|Tq],[_|Tr],F):-
								getLunch(Tq,Tr,F).
								
getDinner([],[],"-").
getDinner([Hq|_],[Hr|_],F):-
								(Hq=[i,ate,F,for,dinner];Hq=[can,i,have,F,for,dinner]),
								(Hr=["Ok"];Hr=["You",can,have,F,for,dinner]).								
getDinner([_|Tq],[_|Tr],F):-
								getDinner(Tq,Tr,F).

								
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
%%%%%%%%       End of Inputs     %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%   QUESTIONS      %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%
%%  STATE FACTS   %%
%%%%%%%%%%%%%%%%%%%%

response(Q,PQ,PR,["Ok"]):-
					Q=[i,ate,_,for,_],
					getDiffAnswer(Q,PQ,PR,["Ok"],_).
response(Q,PQ,PR,["I",told,you,that,before]):-
										Q=[i,ate,_,for,_],
										\+getDiffAnswer(Q,PQ,PR,["Ok"],_).
						
												
response(Q,PQ,PR,["Ok"]):-
					Q=[i,do,not,eat,_],
					getDiffAnswer(Q,PQ,PR,["ok."],_).
response(Q,PQ,PR,["I",told,you,that,before]):-
										Q=[i,do,not,eat,_],
										\+getDiffAnswer(Q,PQ,PR,["Ok"],_).

%%%%%%%%%%%%%%%%%%
%%  Question A  %%
%%%%%%%%%%%%%%%%%%

response(Q,PQ,PR,Result):-
					Q=[how,many,calories,does,F,contain],
					\+prop(F,_,_),
					getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],Result).

response(Q,PQ,PR,Result):-		
					Q=[how,many,calories,does,F,contain],
					once(prop(F,_,_)),
					foodCal(F,CR),
					getDiffAnswer(Q,PQ,PR,[[CR,"Calories"]],Result).

response(Q,PQ,PR,["I",told,you,that,before]):-
										Q=[how,many,calories,does,F,contain],
										once(prop(F,_,_)),
										foodCal(F,CR),
										\+getDiffAnswer(Q,PQ,PR,[[CR,"Calories"]],_).						
response(Q,PQ,PR,["I",told,you,that,before]):-
										Q=[how,many,calories,does,F,contain],
										\+prop(F,_,_),
										\+getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],_).
												
%%%%%%%%%%%%%%%%%%
%%  Question B  %%						
%%%%%%%%%%%%%%%%%%

response(Q,PQ,PR,R):-
				Q=[what,does,F,contain],
				\+prop(F,_,_),
				getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],R).

response(Q,PQ,PR,["I",told,you,that,before]):-
										Q=[what,does,F,contain],
										once(prop(F,_,_)),
										filterProp(contain,L),
										matchFirst(F,L,R),
										bestMatchesMin(R,1,CR),
										\+getDiffAnswer(Q,PQ,PR,CR,_).

response(Q,PQ,PR,["I",told,you,that,before]):-
										Q=[what,does,F,contain],
										\+prop(F,_,_),
										\+getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],_).
												
response(Q,PQ,PR,[Result]):-		
				Q=[what,does,F,contain],
				once(prop(F,_,_)),
				filterProp(contain,L),
				matchFirst(F,L,R),
				bestMatchesMin(R,1,CR),
				getDiffAnswer(Q,PQ,PR,CR,Result).

%%%%%%%%%%%%%%%%%%
%%  Question C  %%
%%%%%%%%%%%%%%%%%%

response(Q,PQ,PR,R):-
				Q = [can,i,have,F,for,M],
				(once((\+prop(_,_,M)));
				(once(\+prop(F,_,_)));once(\+calcCalories(F,PQ,PR,_))),
				\+member(Q,PQ),
				getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],R).
	
response(Q,PQ,PR,["I",told,you,that,before]):-
									Q = [can,i,have,F,for,M],
									once(prop(F,_,_)),
									once(prop(_,_,M)),
									filterProp(not,L),
									matchSecond(M,L,R),
									bestMatchesMin(R,1,CR),
									\+member(F,CR),
									calcCalories(F,PQ,PR,X),
									X>=0,
									member(Q,PQ).
																					
response(Q,PQ,_,["I",told,you,that,before]):-
									Q = [can,i,have,F,for,M],
									once(prop(F,_,_)),
									once(prop(_,_,M)),
									filterProp(not,L),
									matchSecond(M,L,R),
									bestMatchesMin(R,1,CR),
									member(F,CR),
									member(Q,PQ).
									
response(Q,PQ,PR,["I",told,you,that,before]):-
									Q = [can,i,have,F,for,M],
									once(prop(F,_,_)),
									once(prop(_,_,M)),
									calcCalories(F,PQ,PR,X),
									X<0,
									member(Q,PQ).
												
response(Q,PQ,PR,["I",told,you,that,before]):-
										Q = [can,i,have,F,for,M],
										(once((\+prop(_,_,M)));
										(once(\+prop(F,_,_)));once(\+calcCalories(F,PQ,PR,_))),
										member(Q,PQ).	
										
												
response(Q,PQ,PR,Result):-
						Q = [can,i,have,F,for,M],
						once(prop(F,_,_)),
						once(prop(_,_,M)),
						filterProp(not,L),
						matchSecond(M,L,R),
						bestMatchesMin(R,1,CR),
						\+member(F,CR),
						calcCalories(F,PQ,PR,X),
						X>=0,
						\+member(Q,PQ),
						getDiffAnswer(Q,PQ,PR,[["You",can,have,F,for,M]],Result).
response(Q,PQ,PR,Result):-
						Q = [can,i,have,F,for,M],
						once(prop(F,_,_)),
						once(prop(_,_,M)),
						filterProp(not,L),
						matchSecond(M,L,R),
						bestMatchesMin(R,1,CR),
						member(F,CR),
						\+member(Q,PQ),
						getDiffAnswer(Q,PQ,PR,[[F,"is",not,suitable,for,M]],Result).	
response(Q,PQ,PR,[Result]):-
						Q = [can,i,have,F,for,M],
						once(prop(F,_,_)),
						once(prop(_,_,M)),
						calcCalories(F,PQ,PR,X),
						X<0,
						\+member(Q,PQ),
						filterProp(not,L),
						matchSecond(M,L,R),
						bestMatchesMin(R,1,CR),
						\+member(F,CR),
						getDiffAnswer(Q,PQ,PR,["No"],Result).
						
%%%%%%%%%%%%%%%%%%
%%  Question D  %%						
%%%%%%%%%%%%%%%%%%

response(Q,PQ,PR,R):-
				Q = [what,is,F],
				\+prop(F,is,_),
				getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],R).

response(Q,PQ,PR,["I",told,you,that,before]):-
										Q = [what,is,F],
										once(prop(F,is,Type)),
										\+getDiffAnswer(Q,PQ,PR,[Type],_).

response(Q,PQ,PR,["I",told,you,that,before]):-
										Q = [what,is,F],
										\+prop(F,is,_),
										\+getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],_).
response(Q,PQ,PR,[R]):-
				Q = [what,is,F],
				once(prop(F,is,Type)),
				getDiffAnswer(Q,PQ,PR,[Type],R).						

%%%%%%%%%%%%%%%%%%
%%  Question E  %%
%%%%%%%%%%%%%%%%%%
						
response(Q,PQ,PR,Result):-
					Q=[how,many,calories,do,i,have,left],
					calcCalories(tomato,PQ,PR,C),
					C1 is C + 11,
					getDiffAnswer(Q,PQ,PR,[[C1,"Calories"]],Result).

response(Q,PQ,PR,["I",told,you,that,before]):-
										Q=[how,many,calories,do,i,have,left],
										calcCalories(tomato,PQ,PR,C),
										C1 is C + 11,
										\+getDiffAnswer(Q,PQ,PR,[[C1,"Calories"]],_).						

response(Q,PQ,PR,["I",told,you,that,before]):-
										Q=[how,many,calories,do,i,have,left],
										\+calcCalories(tomato,PQ,PR,_),
										\+getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],_).
											
response(Q,PQ,PR,R):-
				Q=[how,many,calories,do,i,have,left],
				\+calcCalories(tomato,PQ,PR,_),
				getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],R).
						
%%%%%%%%%%%%%%%%%%
%%  Question F  %%
%%%%%%%%%%%%%%%%%%

response(Q,PQ,PR,R):-
				Q = [what,kind,of,FC,does,F,contain],
				((\+ prop(_,_,FC));
				(\+prop(F,_,_))),
				getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],R).

response(Q,PQ,PR,R):-
				Q = [what,kind,of,FC,does,F,contain],
				once(prop(_,_,FC)),
				once(prop(F,_,_)),
				filterProp(contain,L1),
				filterProp(is,L2),
				matchFirst(F,L1,R1),
				matchSecond(FC,L2,R2),
				once(mergeMatchLists(R1,R2,L3)),
				bestMatchesMin(L3,2,CR),
				length(CR,0),
				getDiffAnswer(Q,PQ,PR,[["Nothing",from,what,i,know]],R).
											
response(Q,PQ,PR,[R]) :-
				Q = [what,kind,of,FC,does,F,contain],
				once(prop(_,_,FC)),
				once(prop(F,_,_)),
				filterProp(contain,L1),
				filterProp(is,L2),
				matchFirst(F,L1,R1),
				matchSecond(FC,L2,R2),
				once(mergeMatchLists(R1,R2,L3)),
				bestMatchesMin(L3,2,CR),
				length(CR,Len),
				Len >= 1,
				getDiffAnswer(Q,PQ,PR,CR,R).				
				
				
response(Q,PQ,PR,["I",told,you,that,before]):-
										Q = [what,kind,of,FC,does,F,contain],
										once(prop(_,_,FC)),
										once(prop(F,_,_)),
										filterProp(contain,L1),
										filterProp(is,L2),
										matchFirst(F,L1,R1),
										matchSecond(FC,L2,R2),
										once(mergeMatchLists(R1,R2,L3)),
										bestMatchesMin(L3,2,CR),
										length(CR,Len),
										Len >= 1,
										\+getDiffAnswer(Q,PQ,PR,CR,_).

response(Q,PQ,PR,["I",told,you,that,before]):-
										Q = [what,kind,of,FC,does,F,contain],
										((\+ prop(_,_,FC));
										(\+prop(F,_,_))),
										\+getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],_).
												
response(Q,PQ,PR,["I",told,you,that,before]):-
										Q = [what,kind,of,FC,does,F,contain],
										once(prop(_,_,FC)),
										once(prop(F,_,_)),
										filterProp(contain,L1),
										filterProp(is,L2),
										matchFirst(F,L1,R1),
										matchSecond(FC,L2,R2),
										once(mergeMatchLists(R1,R2,L3)),
										bestMatchesMin(L3,2,CR),
										length(CR,0),
										\+getDiffAnswer(Q,PQ,PR,[["Nothing",from,what,i,know]],_).
				
%%%%%%%%%%%%%%%%%%
%%  Question G  %%
%%%%%%%%%%%%%%%%%%

response(Q,PQ,PR,R):-
					Q=[is,ING,a,FC,in,F],
					((\+prop(F,_,_));(\+prop(_,_,FC));(\+prop(ING,_,_))),
					getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],R).												
response(Q,PQ,PR,[R]):-
					Q=[is,ING,a,FC,in,F],
					once(prop(_,_,FC)),
					once(prop(F,_,_)),
					once(prop(ING,_,_)),
					filterProp(contain,L1),
					filterProp(is,L2),
					matchFirst(F,L1,R1),
					matchSecond(FC,L2,R2),
					once(mergeMatchLists(R1,R2,L3)),
					bestMatchesMin(L3,2,CR),
					member(ING,CR),
					getDiffAnswer(Q,PQ,PR,["Yes"],R).
response(Q,PQ,PR,[R]):-
					Q=[is,ING,a,FC,in,F],
					once(prop(_,_,FC)),
					once(prop(F,_,_)),
					once(prop(ING,_,_)),
					filterProp(contain,L1),
					filterProp(is,L2),
					matchFirst(F,L1,R1),
					matchSecond(FC,L2,R2),
					once(mergeMatchLists(R1,R2,L3)),
					bestMatchesMin(L3,2,CR),
					\+member(ING,CR),
					getDiffAnswer(Q,PQ,PR,["No"],R).

						
response(Q,PQ,PR,["I",told,you,that,before]):-
											Q=[is,ING,a,FC,in,F],
											once(prop(_,_,FC)),
											once(prop(F,_,_)),
											once(prop(ING,_,_)),
											filterProp(contain,L1),
											filterProp(is,L2),
											matchFirst(F,L1,R1),
											matchSecond(FC,L2,R2),
											once(mergeMatchLists(R1,R2,L3)),
											bestMatchesMin(L3,2,CR),
											member(ING,CR),
											\+getDiffAnswer(Q,PQ,PR,["Yes"],_).
response(Q,PQ,PR,["I",told,you,that,before]):-
											Q=[is,ING,a,FC,in,F],
											once(prop(_,_,FC)),
											once(prop(F,_,_)),
											once(prop(ING,_,_)),
											filterProp(contain,L1),
											filterProp(is,L2),
											matchFirst(F,L1,R1),
											matchSecond(FC,L2,R2),
											once(mergeMatchLists(R1,R2,L3)),
											bestMatchesMin(L3,2,CR),
											\+member(ING,CR),
											\+getDiffAnswer(Q,PQ,PR,["No"],_).
response(Q,PQ,PR,["I",told,you,that,before]):-
											Q=[is,ING,a,FC,in,F],
											((\+prop(F,_,_));(\+prop(_,_,FC));(\+prop(ING,_,_))),
											\+getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],_).
												
%%%%%%%%%%%%%%%%%%						
%%  Question H  %%
%%%%%%%%%%%%%%%%%%
						
response(Q,PQ,PR,R):-
					Q=[what,can,i,have,for,M,that,contains,ING],
					((\+prop(ING,_,_);\+prop(_,_,M))),
					getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],R).
response(Q,PQ,PR,R):-
					Q=[what,can,i,have,for,M,that,contains,ING],
					once(prop(ING,_,_)),
					once(prop(_,_,M)),
					responseO(Q,PQ,PR,CR),
					CR=[],
					getDiffAnswer(Q,PQ,PR,[["Nothing",from,what,i,know]],R).
							

response(Q,PQ,PR,[R]):- 
						Q=[what,can,i,have,for,M,that,contains,ING],
						once(prop(ING,_,_)),
						once(prop(_,_,M)),
						responseO(Q,PQ,PR,CR),
						CR\=[],
						getDiffAnswer(Q,PQ,PR,CR,R).

						
response(Q,PQ,PR,["I",told,you,that,before]):-
											Q=[what,can,i,have,for,M,that,contains,ING],
											once(prop(ING,_,_)),
											once(prop(_,_,M)),
											responseO(Q,PQ,PR,CR),
											CR=[],
											\+getDiffAnswer(Q,PQ,PR,[["Nothing",from,what,i,know]],_).
response(Q,PQ,PR,["I",told,you,that,before]):-
											Q=[what,can,i,have,for,M,that,contains,ING],
											((\+prop(ING,_,_);\+prop(_,_,M))),
											\+getDiffAnswer(Q,PQ,PR,[["I",do,not,know]],_).												

response(Q,PQ,PR,["I",told,you,that,before]):-  
											Q=[what,can,i,have,for,M,that,contains,ING],
											once(prop(ING,_,_)),
											once(prop(_,_,M)),
											responseO(Q,PQ,PR,CR),
											CR\=[],
											\+getDiffAnswer(Q,PQ,PR,CR,_).												
							
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%    END OF QUESTIONS 	%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%        Predicates        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

totalCal(1800).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  isValid/1  %%%%              DONE          %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

isValid(Q):-
		valQs(Q).

valQs([how,many,calories,does,_,contain]).
valQs([what,does,_,contain]).
valQs([can,i,have,_,for,_]).          
valQs([what,is,_]).
valQs([how,many,calories,do,i,have,left]).                          
valQs([what,kind,of, _, does ,_,contain]).
valQs([is,_,a,_,in,_]).                                                     
valQs([what,can,i,have,for,_,that,contains,_]).
valQs([i,ate,_,for,_]).
valQs([i,do,not,eat,_]).
valQs([quit]).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%		
%%%%  filterProp/2  %%%%           DONE          %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filterProp(Relation,Result):-
					setof((Arg1,Arg2),prop(Arg1,Relation,Arg2),Result).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
%%%%  matchFirst/3  %%%%           DONE         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

matchFirst(_,[],[]).							
matchFirst(T1,[(X1,X2)|TLF],[(E-Occ)|TLM]):-
								T1=X1,
								E=X2,
								Occ=1,
								matchFirst(T1,TLF,TLM).
								
matchFirst(T1,[(X1,X2)|TLF],[(E-Occ)|TLM]):-
								T1\=X1,
								E=X2,
								Occ=0,
								matchFirst(T1,TLF,TLM).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
%%%%  matchSecond/3  %%%%           DONE        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

matchSecond(_,[],[]).							
matchSecond(T1,[(X1,X2)|TLF],[(E-Occ)|TLM]):-
									T1=X2,
									E=X1,
									Occ=1,
									matchSecond(T1,TLF,TLM).
matchSecond(T1,[(X1,X2)|TLF],[(E-Occ)|TLM]):-
									T1\=X2,
									E=X1,
									Occ=0,
									matchSecond(T1,TLF,TLM).
									
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
%%%%  mergeMatchLists/3 %%%% NOT AS THE ONE IN TEST FILE %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  SHOW ONLY ELEMENTS WITH SCORE>0 TO BE HAVING sum AS A SCORE  %%
mergeMatchLists([],_,[]).
mergeMatchLists([F-N|T],ML2,[F-Sum|Tail]):-
										N>0,
										member(F-X,ML2),
										X>0,
										Sum is N+X,
										mergeMatchLists(T,ML2,Tail).
mergeMatchLists([F-N|T],ML2,R):-
								((N=0);
								(\+member(F-_,ML2));member(F-X,ML2)),
								X=0,
								mergeMatchLists(T,ML2,R).
								
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%							
%%%%  bestMatches/2  %%%%           DONE           %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
bestMatches(ML,BL):-
				getNumbers(ML,LN),
				max_list(LN,N),
				getMaxFood(ML,N,BLrev), %% to get food with this max score %%
				reverse(BLrev,BL).
				
getNumbers([],[]).
getNumbers([_-N|T],[N|Tail]):-
						getNumbers(T,Tail).

%getMaxFood(_,1,[]).
getMaxFood([],_,[]).
getMaxFood([F-N1|T],N,[F|Tail]):-
					N1=N,
					getMaxFood(T,N,Tail).
getMaxFood([_-N1|T],N,L):-
				N1\=N,
				getMaxFood(T,N,L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  bestMatchesMin/3  %%%%             DONE        %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bestMatchesMin(ML,MIN,BL):-
					getMaxFood(ML,MIN,BLrev),
					reverse(BLrev,BL).
				
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					
%%%%  foodCal/2  %%%%                    DONE       %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

foodCal(F,C):-
			prop(F,contain,C,cal).
foodCal(F,C):-
			\+prop(F,contain,_,cal),
			filterProp(contain,R),
			filter(F,R,Filtered),
			helper(Filtered,C).
			
filter(_,[],[]).		
filter(F,[(X1,X2)|T],[X2|Tail]):-
						F=X1,
						filter(F,T,Tail).
filter(F,[(X1,_)|T],L):-
				F\=X1,
				filter(F,T,L).

helper([],0).
helper([H|T],C):-
				prop(H,contain,X,cal),
				helper(T,C1),
				C is C1+X.
helper([H|T],C):-
				\+prop(H,contain,_,cal),
				filterProp(contain,R),
				filter(H,R,Filtered),
				calPropList(Filtered,X),
				helper(T,C1),
				C is C1+X.

calPropList([],0).
calPropList([H|T],C):-
				prop(H,contain,X,cal),
				calPropList(T,C1),
				C is X+C1.
							
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%				
%%%%  foodCalList/2  %%%%         DONE    	    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
foodCalList([H],C):-
				foodCal(H,C).
foodCalList([H|T],C):-
				foodCal(H,X),
				foodCalList(T,C1),
				C is X+C1.
											
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%						
%%%%  calcCalories/4  %%%%        DONE         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calcCalories(F,[],[],C):-
						foodCal(F,C1),
						totalCal(X),
						C is X-C1.
calcCalories(F,[Hq|Tq],[Hr|Tr],C):-
								((Hq=[i,ate,PF,for,_],Hr=["Ok"]);(Hq=[can,i,have,PF,for,M],Hr=["You",can,have,PF,for,M])),
								once(prop(PF,_,_)),
								once(prop(_,_,M)),
								foodCal(PF,CP),
								calcCalories(F,Tq,Tr,C1),
								C is C1-CP.
calcCalories(F,[Hq|Tq],[_|Tr],C):-
								Hq\=[i,ate,_,for,_],
								calcCalories(F,Tq,Tr,C).
															
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  getDiffAnswer/5  %%%%          DONE 		  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getDiffAnswer(Q,PQ,PR,[[H|T]|Tail],R):-
							\+isList(H),
							getResponses(Q,PQ,PR,AllResp),
							getDiffLists([[H|T]|Tail],AllResp,R).    %%  helper to give All responses sentences of Question Q   %%
getDiffAnswer(Q,PQ,PR,[H|T],R):-
							\+isList(H),
							getResponses(Q,PQ,PR,AllResp),
							getDiffElement([H|T],AllResp,R).            %%  helper to give All responses element of Question Q  %%							

getDiffLists([[H|T]|_],AllResp,[H|T]):-
							\+member([H|T],AllResp).
getDiffLists([[H|T]|Tail],AllResp,R):-
							member([H|T],AllResp),
							getDiffLists(Tail,AllResp,R).

getDiffElement([H|Tail],AllResp,R):-
							member([H],AllResp),
							getDiffElement(Tail,AllResp,R).
getDiffElement([H|_],AllResp,H):-
							\+member([H],AllResp).
								
getResponses(_,[],[],[]).
getResponses(Q,[[HQs|TQs]|T],[[HRs|TRs]|T1],[[HRs|TRs]|Tail]):-
										Q=[HQs|TQs],
										getResponses(Q,T,T1,Tail).
getResponses(Q,[[HQs|TQs]|T],[_|T1],Tail):-
									Q\=[HQs|TQs],
									getResponses(Q,T,T1,Tail).
									
isList([_|_]).
isList([]).									

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   responseO/4  %%%% 	DONE 	%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

responseO(Q,PQ,PR,LR):-
						Q=[what,can,i,have,for,M,that,contains,ING],
						filterProp(contain,L),
						matchSecond(ING,L,AllFood),	        %%  +1 to food that contains INGredient  %%
						suitableForMeal(AllFood,M,L1),      %%  Add +1 to food that is suitable for Meal(M) %%
						noHatedIngredient(L1,PQ,L2),        %% Add +1 to food that doesn't contain hated ING  %%
						calorieLimit(L2,PQ,PR,L3),			%% add +1 to food that if eaten, user will not exceed calories limit  %%
						listOrderDesc(L3,[_-N|_]),
						N=4,
						bestMatches(L3,LR).
responseO(Q,PQ,PR,[]):-
						Q=[what,can,i,have,for,M,that,contains,ING],
						filterProp(contain,L),
						matchSecond(ING,L,AllFood),		   %%  +1 to food that contains INGredient  %%
						suitableForMeal(AllFood,M,L1),     %%  Add +1 to food that is suitable for Meal(M) %%
						noHatedIngredient(L1,PQ,L2),       %% Add +1 to food that doesn't contain hated ING  %%
						calorieLimit(L2,PQ,PR,L3),		   %% add +1 to food that if eaten, user will not exceed calories limit  %%
						listOrderDesc(L3,[_-N|_]),
						N\=4.
						
suitableForMeal([],_,[]).
suitableForMeal([F-N|T],M,[F-N1|T1]):-
								filterProp(not,L),
								matchSecond(M,L,R),
								bestMatchesMin(R,1,CR),
								\+member(F,CR),
								N1 is N+1,
								suitableForMeal(T,M,T1).
suitableForMeal([F-N|T],M,[F-N|T1]):-
								filterProp(not,L),
								matchSecond(M,L,R),
								bestMatchesMin(R,1,CR),
								member(F,CR),
								suitableForMeal(T,M,T1).


noHatedIngredient([],_,[]).								
noHatedIngredient([F-N|T],PQ,[F-N1|T1]):-
						filterProp(contain,L),
						matchFirst(F,L,R),
						bestMatchesMin(R,1,CR),  %% CR: Ingerdients of that food  %%
						getUnlikedIngredients(PQ,FL),
						intersection(CR,FL,[]),   %% no intersection means that food's ingredients doesn't contain any ingredients that the user hate  %%
						N1 is N+1,
						noHatedIngredient(T,PQ,T1).
noHatedIngredient([F-N|T],PQ,[F-N|T1]):-
						filterProp(contain,L),
						matchFirst(F,L,R),
						bestMatchesMin(R,1,CR),  %% CR: Ingerdients of that food  %%
						getUnlikedIngredients(PQ,FL),
						\+intersection(CR,FL,[]),   %% intersection means that food's ingredients contain any ingredients that the user hate  %%
						noHatedIngredient(T,PQ,T1).

calorieLimit([],_,_,[]).						
calorieLimit([F-N|T],PQ,PR,[F-N1|T1]):-
								calcCalories(F,PQ,PR,X),
								X>=0,              %% doesn't exceed Cal Limit  %%
								N1 is N+1,
								calorieLimit(T,PQ,PR,T1).
calorieLimit([F-N|T],PQ,PR,[F-N|T1]):-
								calcCalories(F,PQ,PR,X),
								X<0,               %% exceeds Cal Limit  %%
								calorieLimit(T,PQ,PR,T1).
								
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  listOrderDesc/2  %%%% 	DONE 	%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

listOrderDesc(LP,OLP):-
					i_sort(LP,[],OLP).
							
i_sort([],X,X).
i_sort([H|T],Accumulator,Sorted):-
							insert(H,Accumulator,N),
							i_sort(T,N,Sorted).
									
insert(X1-X2,[Y1-Y2|T],[Y1-Y2|NT]):-
							X2<Y2,
							insert(X1-X2,T,NT).
insert(X1-X2,[Y1-Y2|T],[X1-X2,Y1-Y2|T]):-
									X2>=Y2.
insert(X1-X2,[],[X1-X2]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  foodFromHistory/2  %%%%   		DONE      		 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

foodFromHistory([],[]).
foodFromHistory([H|T],[H1|T1]):-
							(H=[i,ate,F,for,_];H=["You",can,have,F,for,_]),
							H1=F,
							foodFromHistory(T,T1).
foodFromHistory([H|T],FL):-
						H\=[i,ate,_,for,_],
						H\=["You",can,have,_,for,_],
						foodFromHistory(T,FL).
					
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%								
%%%%  getUnlikedIngredients/2  %%%% 	 	DONE  			%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getUnlikedIngredients([],[]).
getUnlikedIngredients([H|T],[H1|T1]):-
								H=[i,do,not,eat,F],
								H1=F,
								getUnlikedIngredients(T,T1).
getUnlikedIngredients([H|T],FL):-
								H\=[i,do,not,eat,_],
								getUnlikedIngredients(T,FL).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%   END OF PREDICATES  %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%