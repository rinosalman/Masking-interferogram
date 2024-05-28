%% Obtain masked_areas indices from PNG image
% Cheryl Tay, 20 Oct 2023

clear all; close all

%% Inputs 

% Load image 
image = imread('out_masked.png');

% Length of square in pixels 
squareSideLength = 7;

%% Find black pixels 

% Get dimensions of image
maxRow = size(image,1);
maxCol = size(image,2);

% Convert the image to grayscale (if not already grayscale)
if size(image, 3) > 1
    grayImage = rgb2gray(image);
else
    grayImage = image;
end

% Threshold the image to identify completely black pixels
threshold = 0;  
binaryImage = grayImage <= threshold;

% Find the polygons of each black pixel cluster
boundaries = bwboundaries(binaryImage);

% Show polygons found
figure; imshow(image); hold on
for k = 1:length(boundaries)
    polygon = boundaries{k};
    plot(polygon(:,2), polygon(:,1), 'r', 'LineWidth', 2); hold on
end

%% Approximate polygon using many smaller squares

% To save masked_string in the following format:
% [[first_row,last_row,first_col,last_col], [first_row,last_row,first_col,last_col]]
masked_string = '[';

figure; 

% Approximate for each polygon
for k = 1:length(boundaries)

    polygon = boundaries{k};
    plot(polygon(:,2), polygon(:,1), 'r', 'LineWidth', 2); hold on
   
    % Determine the bounding box of the polygon
    minX = min(polygon(:, 1));
    maxX = max(polygon(:, 1));
    minY = min(polygon(:, 2));
    maxY = max(polygon(:, 2));
    
    % Calculate the number of squares needed in both dimensions
    numX = ceil((maxX - minX) / squareSideLength);
    numY = ceil((maxY - minY) / squareSideLength);
    
    % Initialize a cell array to store square coordinates
    squares = cell(numX, numY);
    
    % Generate squares to cover the polygon
    for i = 1:numX
        for j = 1:numY
            % Define square vertices based on current position
            squareX = [minX + (i - 1) * squareSideLength, minX + i * squareSideLength, minX + i * squareSideLength, minX + (i - 1) * squareSideLength, minX + (i - 1) * squareSideLength];
            squareY = [minY + (j - 1) * squareSideLength, minY + (j - 1) * squareSideLength, minY + j * squareSideLength, minY + j * squareSideLength, minY + (j - 1) * squareSideLength];
            
            % Check if any part of the square is inside the polygon
            inPolygon = inpolygon(squareX, squareY, polygon(:, 1), polygon(:, 2));
            
            % If any part of the square is inside the polygon, store its coordinates
            if any(inPolygon)
                squares{i, j} = [squareX; squareY];
            end
        end
    end
    
    % Remove empty cells from the cell array
    squares = squares(~cellfun('isempty', squares));
    
    % Quality check for each square 
    for i = 1:numel(squares)

        square = squares{i};

        % Limit square to within image dimensions
        square(1, square(1,:)>maxRow) = maxRow;
        square(2, square(2,:)>maxCol) = maxCol;

        % Display the square
        plot(square(2, :), square(1, :), 'k');

        % Append the square to masked_string
        row1 = num2str(min(square(1,:)));
        row2 = num2str(max(square(1,:)));
        col1 = num2str(min(square(2,:)));
        col2 = num2str(max(square(2,:)));
        substring = ['[',row1,',',row2,',',col1,',',col2,']'];
        masked_string = [masked_string,substring,','];

    end

    axis equal;

end

%% Print squares in string format as required in alosStack

masked_string = [masked_string(1:end-1),']'];
disp(masked_string)
