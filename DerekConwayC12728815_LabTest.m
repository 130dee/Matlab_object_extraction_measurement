%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Derek Conway C12728815
%   Image Processing Class Test 28/04/16
%   Draw a line through the centre of the ruler,
%   Get the pixels per cm
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   The algorithm has only been tested on the ruler image and magic numbers
%   have been used to threshold and travers the cornerpoints array
%   Corners were obtained using edge detection and then applying bwmorph
%   function to make the line 1 pixel wide and getting the endpoints of the
%   line.
%   Given the time limit imposed, I was not able to implement the algorith
%   without using magic numbers, an improvement that could be rectified.
%   I also have not come accross the theorum of 'best fit', so I used the
%   distace between points to get the mid point of the ends of the ruler to
%   plot the centre line manually.
%   The length of the line was obtained using pythagorus on these two
%   points.
%   As such the algorithm will most likely only work on this image.
%   
%   That's all from me and thanks for you efforts sharing your knowledge of
%   Matlab, Its a program that I will enjoy using in the future. With the
%   focus on completing the year, I couldn't spend as much time with it as
%   I would like. Your assignments have been fun too, and I'm now off to
%   complete the project.


clc % clear screen
clear all % clear memory
close all % close any open images
%Read image and make a working copy
sopen = strel('disk',5);
Original = imread('ruler.jpg');
I = im2double(Original);
I = rgb2gray(I);
BW = I > 0.85;
New = BW.*I;
New = imopen(New,sopen);
New=~New;
imshow(New),title 'Extracted object from image';
BW = im2double(New);

%Sobel_Fieldman filter for edge detection
SobelH = [1 0 -1;
          2 0 -2;
          1 0 -1]/4;
      
SobelV = [-1 -2 -1;
           0  0  0;
           1  2  1]/4;

%Apply the edge detector
Ix = conv2(BW,SobelH,'same');

Iy = conv2(BW,SobelV,'same');
%Get an images of horizontal and vertical edges
EH =(Ix - min(Ix(:)))/(max(Ix(:))-min(Ix(:)));
EV =(Iy - min(Iy(:)))/(max(Iy(:))-min(Iy(:)));



%%%%%%%%%     Find the corners %%%%%%%%%%%%%%%%%%%%%%%%%%

g = [1 4 1; 4 7 4; 1 4 1]/27;
    
Ix2 = conv2(Ix.^2, g, 'same'); % Smoothed squared image derivatives
Iy2 = conv2(Iy.^2, g, 'same');
Ixy = conv2(Ix.*Iy, g, 'same');


a = 0.04;
Output = Ixy;
%Output = imopen(Output,sclose);
Output = imclose(Output,sopen);
figure, imshow (Output),title 'edge';




%Skeleton image to plot the corner points
ThinLineImage = bwmorph(Output,'thin',inf);
figure;
imshow(Original), title 'Finished Ruler'; 
Corners = bwmorph(ThinLineImage, 'endpoints');

hold all;
% Get the points of interest and plot tem
[y,x] = find(Corners); 
XYpoints = [y,x];
plot(x,y,'*','LineWidth',2,'Color','red');

xValue = [((x(3)+x(4))/2),((x(1)+x(2))/2)];


yValue = [((y(3)+y(4))/2),((y(1)+y(2))/2)];


plot(xValue,yValue,'LineWidth',2,'Color','Red');

%pythagarous theorum to get the length of the line from 2 points

lengthOfLine = sqrt(abs((xValue(1))-(xValue(2))^2)+abs((yValue(1))-(yValue(2))^2));
pixelsPerCm = int64(lengthOfLine/16);
outputString = sprintf('There are %d pixels per cm on the image',pixelsPerCm);

text(100,100,outputString);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                        ATTEMPT AT LINE OF BEST FIT


ValueOfx=0;
ValueOfy=0;
counterPoints=length(XYpoints);
figure,imshow(Original), title 'Line of best fit';

%get sum of all x values and y values
for i=1:length(XYpoints);
    xy = XYpoints(i);
    ValueOfx=ValueOfx+(x(i));
    ValueOfy=ValueOfy+(y(i));
end
%divide the sums by the number of corner points
meanX= ValueOfx/counterPoints;
meanY= ValueOfy/counterPoints;

%after doing the above, I discover that a line can be applied by:

%http://uk.mathworks.com/matlabcentral/answers/89335
%-how-do-i-make-a-best-fit-line-along-with-getting-r-2-on-matlab
coeffs = polyfit(x, y, 1);
% Get fitted values
BestFitX = linspace(((x(1)+x(2))/2),((x(3)+x(4))/2), 100);
BestFitY = polyval(coeffs, BestFitX);
% Plot the fitted line
hold on;
plot(BestFitX, BestFitY, 'r-', 'LineWidth', 2);

