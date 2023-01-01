% Q3.3.1
book_mov = loadVid("../data/book.mov");
panda_mov = loadVid("../data/ar_source.mov");

book_img = imread("../data/cv_cover.jpg");

ar_file = VideoWriter('../results/ar_dest.avi'); 
open(ar_file);

for i = 1:size(panda_mov, 2)
    
    book_frame = book_mov(i).cdata;
    panda_frame = panda_mov(i).cdata;

%     figure;
%     imshow(panda_frame);
%     axis on; - To see the image and crop based on this

%     Cropping out 45 pixels from height and 200 pixels from width
    panda_frame = panda_frame(45:315, 200:440, :);
    panda_frame = imresize(panda_frame, [size(book_img, 1), size(book_img, 2)]);

    [locs1, locs2] = matchPics(book_img, book_frame);
    
    try
        [bestH2to1, ~, ~] = computeH_ransac(locs1, locs2);
    catch
        disp("Continuing");
        if not (exist("bestH2to1", "var"))
            continue;
        end
    end
    
%     if(cond(bestH2to1) > 1e5)
%         if(exist('H2to1', 'var'))
%             bestH2to1 = H2to1; 
%         end
%     end

%     H2to1 = bestH2to1;
    combined_frame = compositeH(inv(bestH2to1), panda_frame, book_frame);


%     figure;
%     imshow(combined_frame);

    writeVideo(ar_file, combined_frame);
end

close(ar_file);