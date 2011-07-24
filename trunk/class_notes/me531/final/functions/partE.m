function [ ] = partE( )

% is the system observable at all speeds between 2.5 m/s and 9 m/s with:
% only p, only d, both?

	ranks1 = [];
	ranks2 = [];
	ranks3 = [];
	flag = 0;

	% only Tp
	for v = 2.5:0.001:9
		[A B C D] = createSysMats(v);

		% Mask Td from the C matrix
		C = C .* [1 0 0 0; 0 0 0 0];

		Omat = obsv(A,C);
		if (rank(Omat) ~= length(A(:,1)))
			fprintf('O matrix is not full rank for v=%1.3f\n',v);
			flag = 1;
		end
		ranks1 = [ranks1 rank(Omat)];
	end

	% only Td
	for v = 2.5:0.001:9
		[A B C D] = createSysMats(v);

		% Mask Tp from the C matrix
		C = C .* [1 0 0 0; 0 0 0 0];

		Omat = obsv(A,C);
		if (rank(Omat) ~= length(A(:,1)))
			fprintf('O matrix is not full rank for v=%1.3f\n',v);
			flag = 1;
		end
		ranks2 = [ranks2 rank(Omat)];
	end

	% the whole banna
	for v = 2.5:0.001:9
		[A B C D] = createSysMats(v);

		Omat = obsv(A,C);
		if (rank(Omat) ~= length(A(:,1)))
			fprintf('O matrix is not full rank for v=%1.3f\n',v);
			flag = 1;
		end
		ranks3 = [ranks3 rank(Omat)];
	end

	if (flag == 0)
		fprintf('All O matrix are full rank - system is fully observable\n');
	end
	
end

