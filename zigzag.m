function output=zigzag(input)

[rows, cols]=size(input);

% Initialise the output vector
output=zeros(1,rows*cols);

currentRow=1;	currentCol=1;	currentIndex=1;

% First element
%out(1)=in(1,1);

while currentRow<=rows & currentCol<=cols
	if currentRow==1 & mod(currentRow+currentCol,2)==0 & currentCol~=cols
		output(currentIndex)=input(currentRow,currentCol);
		currentCol=currentCol+1;							%move right at the top
		currentIndex=currentIndex+1;
		
	elseif currentRow==rows & mod(currentRow+currentCol,2)~=0 & currentCol~=cols
		output(currentIndex)=input(currentRow,currentCol);
		currentCol=currentCol+1;							%move right at the bottom
		currentIndex=currentIndex+1;
		
	elseif currentCol==1 & mod(currentRow+currentCol,2)~=0 & currentRow~=rows
		output(currentIndex)=input(currentRow,currentCol);
		currentRow=currentRow+1;							%move down at the left
		currentIndex=currentIndex+1;
		
	elseif currentCol==cols & mod(currentRow+currentCol,2)==0 & currentRow~=rows
		output(currentIndex)=input(currentRow,currentCol);
		currentRow=currentRow+1;							%move down at the right
		currentIndex=currentIndex+1;
		
	elseif currentCol~=1 & currentRow~=rows & mod(currentRow+currentCol,2)~=0
		output(currentIndex)=input(currentRow,currentCol);
		currentRow=currentRow+1;		currentCol=currentCol-1;	%move diagonally left down
		currentIndex=currentIndex+1;
		
	elseif currentRow~=1 & currentCol~=cols & mod(currentRow+currentCol,2)==0
		output(currentIndex)=input(currentRow,currentCol);
		currentRow=currentRow-1;		currentCol=currentCol+1;	%move diagonally right up
		currentIndex=currentIndex+1;
		
	elseif currentRow==rows & currentCol==cols	%obtain the bottom right element
        output(end)=input(end);							%end of the operation
		break										%terminate the operation
    end
end