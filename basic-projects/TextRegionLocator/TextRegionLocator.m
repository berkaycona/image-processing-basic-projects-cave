imageFilenames = {'paper_with_text1.jpg', 'paper_with_text2.jpg', 'paper_with_text3.jpg', 'paper_with_text4.jpg'};

numImages = length(imageFilenames);

figure;

% Process and display each image
for imgIdx = 1:numImages
    
    input_image = imread(imageFilenames{imgIdx});% Read the input image

    
    ocrObj = ocr(input_image);% Create an OCR object with the default language (English)

    
    wordLocations = ocrObj.WordBoundingBoxes;% Get the location of the recognized text

    
    lineLocations = mergeWordBoxesIntoLineBoxes(wordLocations);% Combine word boxes into line boxes

    
    output_image = input_image;% Draw filled rectangles around the recognized text lines with no borders
    for i = 1:size(lineLocations, 1)
        output_image = insertShape(output_image, 'FilledRectangle', lineLocations(i, :), 'Color', 'blue', 'Opacity', 0.3);
    end

    % Display the input and output images
    subplot(numImages, 2, 2 * imgIdx - 1);
    imshow(input_image);
    title(['Input Image ' num2str(imgIdx)]);

    subplot(numImages, 2, 2 * imgIdx);
    imshow(output_image);
    title(['Recognized Text Lines ' num2str(imgIdx)]);
end

% Function to merge word boxes into line boxes
function lineLocations = mergeWordBoxesIntoLineBoxes(wordLocations)
    % Set the maximum vertical distance between words in the same line
    maxYDist = 10;

    % Initialize the line locations array
    lineLocations = [];

    % Sort word locations by their top-left Y-coordinate
    sortedWordLocations = sortrows(wordLocations, 2);

    % Process each word location
    while size(sortedWordLocations, 1) > 0
        % Get the first word location
        firstWordLocation = sortedWordLocations(1, :);

        % Find all word locations on the same line as the first word
        sameLineIndices = abs(sortedWordLocations(:, 2) - firstWordLocation(2)) <= maxYDist;

        % Merge the word locations on the same line into a single line box
        sameLineLocations = sortedWordLocations(sameLineIndices, :);
        lineBox = [min(sameLineLocations(:, 1)), ...
                   min(sameLineLocations(:, 2)), ...
                   max(sameLineLocations(:, 1) + sameLineLocations(:, 3)) - min(sameLineLocations(:, 1)), ...
                   max(sameLineLocations(:, 2) + sameLineLocations(:, 4)) - min(sameLineLocations(:, 2))];

        % Add the line box to the line locations array
        lineLocations = [lineLocations; lineBox];

        % Remove the processed word locations
        sortedWordLocations(sameLineIndices, :) = [];
    end
end
