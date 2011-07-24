function PI = eval_PI(t,PI_soln,A)
	X = deval(PI_soln, t);
	PI = reshape(X,size(A));
end