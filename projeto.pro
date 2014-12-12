:- use_module(library(clpfd)).
:- use_module(library(lists)).

%
%	SWI-Prolog Source
%

flatten(List, FlatList) :-
	flatten(List, [], FlatList0), !,
	FlatList = FlatList0.

flatten(Var, Tl, [Var|Tl]) :-
	var(Var), !.

flatten([], Tl, Tl) :- !.

flatten([Hd|Tl], Tail, List) :- !,
	flatten(Hd, FlatHeadTail, List),
	flatten(Tl, Tail, FlatHeadTail).

flatten(NonList, Tl, [NonList|Tl]).

%	---

calculate_total_cost([], [], Result, Result).

calculate_total_cost([A | B], [C | D], CurrentSum, Result) :-
	X #= A * C,
	
	InnerResult #= CurrentSum + X,
	
	calculate_total_cost(B, D, InnerResult, Result).

calculate_outside([], [], Result, Result).

calculate_outside([A | B], [C | D], CurrentSum, Result) :-
	calculate_total_cost(A, C, CurrentSum, NewResult),
	
	calculate_outside(B, D, NewResult, Result).

%	+-----------------------+
%	| Calculate Necessities |
%	+-----------------------+

calculate_necessities_for_line([], Necessity, X) :-
	X #= Necessity.

calculate_necessities_for_line([CFLineHeader | CFLineTail], Necessity, X) :-
	Y #= X + CFLineHeader,
	
	calculate_necessities_for_line(CFLineTail, Necessity, Y).

calculate_necessities_2([], []).

calculate_necessities_2([CFHeader | CFTail], [NecHeader | NecTail]) :-
	X #= 0,
	
	calculate_necessities_for_line(CFHeader, NecHeader, X),
	
	calculate_necessities_2(CFTail, NecTail).

calculate_necessities(ClienteFabrica, Necessidades) :-
	transpose(ClienteFabrica, CFTransposed),
	
	calculate_necessities_2(CFTransposed, Necessidades).

%	+----------------------+
%	| Calculate Capacities |
%	+----------------------+

calculate_capacities_for_line([], Capacity, X) :-
	X #=< Capacity.

calculate_capacities_for_line([CFLineHeader | CFLineTail], Capacity, X) :-
	Y #= X + CFLineHeader,

	calculate_capacities_for_line(CFLineTail, Capacity, Y).

calculate_capacities([], []).

calculate_capacities([CFHeader | CFTail], [CapHeader | CapTail]) :-
	X #= 0,
	
	calculate_capacities_for_line(CFHeader, CapHeader, X),

	calculate_capacities(CFTail, CapTail).

%	---

%
%	- ClienteFabrica, -ResultValue, + Capacidades, + Necessidades, + Custos
%

projeto(ClienteFabrica, ResultValue, Capacidades, Necessidades, Custos) :-
	ClienteFabrica = [[C1, C2, C3], [C4, C5, C6], [C7, C8, C9]],
	
	flatten(ClienteFabrica, ClienteFabricaFlattened),
	
	domain(ClienteFabricaFlattened, 1, 1000),
	
	calculate_capacities(ClienteFabrica, Capacidades),
	
	calculate_necessities(ClienteFabrica, Necessidades),
	
	calculate_outside(Custos, ClienteFabrica, 0, ResultValue),
	
	labeling([minimize(ResultValue)], ClienteFabricaFlattened).
	