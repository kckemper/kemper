function [ ] = partB( )

	% check controllability (rank) over the range of velocites

	ranks1 = [];
	ranks2 = [];
	ranks3 = [];
	flag = 0;

	% only Tp
	for v = 2.5:0.001:9
		[A B C D] = createSysMats(v);

		% Mask Td from the B matrix
		B = B .* [1 0; 1 0; 1 0; 1 0];

		Cmatrix = ctrb(A,B);
		if (rank(Cmatrix) ~= length(A(:,1)))
			fprintf('C matrix is not full rank for v=%1.3f\n',v);
			flag = 1;
		end
		ranks1 = [ranks1 rank(Cmatrix)];
	end

	% only Td
	for v = 2.5:0.001:9
		[A B C D] = createSysMats(v);

		% Mask Tp from the B matrix
		B = B .* [0 1; 0 1; 0 1; 0 1];

		Cmatrix = ctrb(A,B);
		if (rank(Cmatrix) ~= length(A(:,1)))
			fprintf('C matrix is not full rank for v=%1.3f\n',v);
			flag = 1;
		end
		ranks2 = [ranks2 rank(Cmatrix)];
	end

	% the whole banna
	for v = 2.5:0.001:9
		[A B C D] = createSysMats(v);

		Cmatrix = ctrb(A,B);
		if (rank(Cmatrix) ~= length(A(:,1)))
			fprintf('C matrix is not full rank for v=%1.3f\n',v);
			flag = 1;
		end
		ranks3 = [ranks3 rank(Cmatrix)];
	end

	if (flag == 0)
		fprintf('All C matrix are full rank\n');
	end


end

