input_image = imread('dog.jpg');

% Converting the input image to grayscale. Converting the input image to grayscale simplifies the processing because it reduces the number of color channels to one. A grayscale image has only intensity information, whereas a color image has separate red, green, and blue channels. By converting the image to grayscale, we can apply the filtering methods on a single channel, making the computations easier and faster.
input_image = rgb2gray(input_image);

% Adding salt-and-pepper noise to the input image
noisy_image = imnoise(input_image, 'salt & pepper', 0.05);

% Testing different threshold values for D
D_values = [1, 255, 55];
num_D_values = numel(D_values); % calculates the number of elements in the D_values array. numel is a built-in MATLAB function that returns the number of elements in an array. 

figure;

for i = 1:num_D_values
    D = D_values(i);
    
    % Apply the outlier method of filtering
    filtered_image = outlier_filter(noisy_image, D);
    
    % Display the filtered image in a subplot
    subplot(1, num_D_values, i);
    imshow(filtered_image);
    title(['D value is ', num2str(D)]);
end



% Apply the median filter
median_filtered_image = medfilt2(noisy_image);

% Display the original noisy image
figure;
imshow(noisy_image);
title('Noisy Image');

% Display the median filtered image
figure;
imshow(median_filtered_image);
title('Median Filtered Image');

function output_image = outlier_filter(input_image, D) % The function takes two input arguments: input_image and D. input_image is the noisy image that we want to filter, and D is the threshold value for the outlier method of filtering.
    [rows, cols] = size(input_image); % retrieves the dimensions of the input image in terms of rows and columns.
    output_image = input_image; % initializes the output image as a copy of the input image. This allows to modify the output image while preserving the original input image.
    
    %iterate through each pixel in the input image, except the border pixels.
    for row = 2:rows-1
        for col = 2:cols-1
            window = input_image(row-1:row+1, col-1:col+1); %  extracts a 3x3 window around the current pixel, including the pixel itself.
            p = input_image(row, col); % stores the intensity value of the current pixel.
            window = window([1:4, 6:9]); %  removes the central pixel (current pixel) from the window by creating a new array that includes only the neighboring pixels. The original window is a 3x3 matrix, and the central pixel is at index 5. The expression [1:4, 6:9] creates an array containing the indices [1, 2, 3, 4, 6, 7, 8, 9]. By using this array as an index for the window, we create a new array with only the neighboring pixels, effectively removing the central pixel.
            m = mean(window(:)); % calculates the mean intensity value of the neighboring pixels by first reshaping the window array into a single column using the colon (:) operator. The colon operator, when used in this context, reshapes an array into a single column by stacking its columns one below the other. This operation does not affect the values themselves, only their arrangement in memory.
            
            if abs(p - m) > D % checks if the absolute difference between the current pixel value and the mean of its neighbors is greater than the threshold D. If it is, the current pixel is considered noise.
                output_image(row, col) = m; % If the current pixel is classified as noise, its value in the output image is replaced with the mean of its neighboring pixels.
            end
        end
    end
end
