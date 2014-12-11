:- use_module(library(clpfd)).
:- use_module(library(lists)).

calculate_total_cost([], [], Result, Result).

calculate_total_cost([A | B], [C | D], CurrentSum, Result) :-
	X #= A * C,
	
	InnerResult #= CurrentSum + X,
	
	calculate_total_cost(B, D, InnerResult, Result).

%	---

remove_elements_from_list(ReturnList, 0, ReturnList).

remove_elements_from_list([H | T], NumElements, ReturnList) :-
	NewE = NumElements - 1,
	remove_elements_from_list(T, NewE).
	
%	---

calculate_capacities_for_line(_, 0, X, MaxCapacity) :-
	X #=< MaxCapacity.

calculate_capacities_for_line([H | T], NumClientes, X, MaxCapacity) :-
	X #= X + H,
	NewClientes is NumClientes - 1,
	
	calculate_capacities_for_line(T, X, NewClientes, MaxCapacity).

calculate_capacities(ClienteFabrica, [CapHeader | CapTail], NumFabricas, NumClientes) :-
	calculate_capacities_for_line(ClienteFabrica, NumClientes, X, CapHeader),
	
	NewFabricas is NumFabricas - 1,
	
	remove_elements_from_list(ClienteFabrica, NumClientes, NewClienteFabrica),
	calculate_capacities(NewClienteFabrica, CapTail, NewFabricas, NumClientes).

%	---

calculate_necessities_for_column([H | T], )

calculate_necessities(ClienteFabrica, [NecHeader | NecTail], NumFabricas, NumClientes) :-
	

%	---

projeto(ClienteFabrica, Custos, Capacidades, Necessidades, NumClientes, NumFabricas, ResultValue) :-
	%	ClienteFabrica = [C1, C2, C3, C4, C5, C6, C7, C8, C9],
	
	domain(ClienteFabrica, 1, 1000),
	
	calculate_capacities(ClienteFabrica, Capacidades, NumFabricas, NumClientes),
	
	%	Custos = [10, 20, 15, 5, 25, 10, 5, 5, 30],
	
	/*	-> Capacidades
		C1 + C2 + C3 #=< 20,
		C4 + C5 + C6 #=< 20,
		C7 + C8 + C9 #=< 20,
	*/
	
	/*	->	Necessidades
		C1 + C4 + C7 #= 10,
		C2 + C5 + C8 #= 30,
		C3 + C6 + C9 #= 20,
	*/
	
	calculate_total_cost(Custos, ClienteFabrica, 0, ResultValue),
	
	labeling([minimize(ResultValue)], ClienteFabrica).
	