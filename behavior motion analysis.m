clear all
root_dir = 'D:\To\Your\Path\';
filenames = dir([root_dir, '*00.csv']);
file_num = size(filenames,1);
writing_dir = 'D:\To\Your\Path.xlsx\';
strategy_dir = 'D:\To\Your\Path\pathfinder\strategy\';

file_name={}; trial_name=[]; time_video_all = [ ]; time_totalw=[]; time_select_percent_all = []; load_frame = []; time_inw=[]; time_in_percent=[]; length_bodycenter_all_realw=[];
length_bodycenter_in_realw=[]; length_bodycenter_out_realw=[]; length_bodycenter_in_percentw=[]; time_still_bodycenter=[]; time_object1=[]; time_object2=[];
time_object1_nose = []; time_object2_nose = []; time_object1_body=[]; time_object2_body=[]; velocity_totalw=[]; velocity_inw=[]; velocity_outw=[];
velocity_in_percent=[]; center_entry_times=[]; center_exit_times=[]; length_body_real=[]; rot_body_trajectory_realw=[]; rot_body_anglew=[]; 
rot_body_velocity=[]; time_still_body_rotation=[]; time_still_body_velocity_rotation=[]; length_tail_real=[]; 
rot_tail_trajectory_realw=[]; rot_tail_anglew=[]; rot_tail_velocity=[]; time_still_tail_rotation=[]; time_still_tail_velocity_rotation=[];
length_bodycenter_before_realw = []; length_bodycenter_after_realw = []; velocity_beforew = []; velocity_afterw = [];
rot_tail_trajectory_before_realw = [];rot_tail_trajectory_after_realw = []; rot_tail_velocity_before = []; rot_tail_velocity_after = [];
rot_body_trajectory_before_realw = [];rot_body_trajectory_after_realw = []; rot_body_velocity_before = []; rot_body_velocity_after = [];
time_beforew = []; time_afterw = []; length_bodycenter_10s_realw =[];

length_nose_in_realw=[]; length_nose_all_realw=[]; length_nose_in_percentw=[]; time_nose_totalw=[]; time_nose_inw=[];
time_nose_in_percent=[]; time_still_nose=[]; velocity_nose_totalw=[]; velocity_nose_inw=[]; velocity_nose_in_percent=[];
center_entry_times_nose=[]; center_exit_times_nose=[];swing_frequencyw=[]; swing_cross_frequencyw=[]; time_to_platform = [];
time_nose_to_platform = []; swing_frequency_beforew = []; swing_frequency_afterw = []; swing_cross_frequency_beforew = []; swing_cross_frequency_afterw = [];
rot_body_trajectory_absw = []; rot_body_trajectory_ratew = []; rot_body_time_ratew = []; rot_body_angle_absw = []; rot_body_angle_ratew = []; 
rot_tail_trajectory_absw = []; rot_tail_trajectory_ratew = []; rot_tail_time_ratew = []; rot_tail_angle_absw = []; rot_tail_angle_ratew = []; 
time_in_tarw = []; time_in_secw = []; time_in_thirdw = []; time_in_fourw = [];

rot_tail_plot = {}; rot_body_plot = {};


for i = 1:file_num
    file_dir = [root_dir, filenames(i).name];
    data = importdata(file_dir);
    file_split = strsplit(filenames(i).name, '_cut');
    file_name{i} = file_split{1};
    
    %body coordinates
    bodycenter_x = data.data(:,11);
    bodycenter_y = data.data(:,12);
    nose_x = data.data(:,2);
    nose_y = data.data(:,3);
    length_bodycenter_pieces = sqrt(diff(bodycenter_x).^2+diff(bodycenter_y).^2);
    length_nose_pieces = sqrt(diff(nose_x).^2+diff(nose_y).^2);
    
    time_video = size(nose_x, 1)/16;
    load_num = 17;
    end_num = size(bodycenter_x, 1);
    abnormal_frame = find(length_bodycenter_pieces>50);
    
    if size(abnormal_frame, 1) == 1
        if abnormal_frame/size(bodycenter_x, 1)>0.5
            end_num = abnormal_frame;
        else
            load_num = abnormal_frame+1;
        end
    elseif size(abnormal_frame, 1) > 1
        frame_list = [1; abnormal_frame; size(bodycenter_x, 1)]';
        frame_length = diff(frame_list);
        [a, max_index] = max(frame_length);
        load_num = frame_list(max_index)+1;
        end_num = frame_list(max_index+1);
    end
    
    if load_num < 17
        load_num = 17;
    end
    
    load_frame = [load_frame; load_num];
    
    bodycenter_x = data.data([load_num:end_num],11);
    bodycenter_y = data.data([load_num:end_num],12);
    nose_x = data.data([load_num:end_num],2);
    nose_y = data.data([load_num:end_num],3);
    back_x = data.data([load_num:end_num],14);
    back_y = data.data([load_num:end_num],15);
    tail_middle_x = data.data([load_num:end_num],17);
    tail_middle_y = data.data([load_num:end_num],18);
    tail_end_x = data.data([load_num:end_num],20);
    tail_end_y = data.data([load_num:end_num],21);

    trial_name = [trial_name; 'watermaze'];

    %boundary coordinates
    corner1_x = data.data([load_num:end_num],23);
    corner1_y = data.data([load_num:end_num],24);
    corner2_x = data.data([load_num:end_num],26);
    corner2_y = data.data([load_num:end_num],27);
    corner3_x = data.data([load_num:end_num],29);
    corner3_y = data.data([load_num:end_num],30);
    corner4_x = data.data([load_num:end_num],32);
    corner4_y = data.data([load_num:end_num],33);
    corner5_x = data.data([load_num:end_num],35); 
    corner5_y = data.data([load_num:end_num],36);
    platform_x = data.data([load_num:end_num],38);
    platform_y = data.data([load_num:end_num],39);
    platform_likelihood = data.data([load_num:end_num],40);
    
    coor_corner1 = [median(corner1_x), median(corner1_y)];
    coor_corner2 = [median(corner2_x), median(corner2_y)];
    coor_corner3 = [median(corner3_x), median(corner3_y)];
    coor_corner4 = [median(corner4_x), median(corner4_y)];
    coor_corner5 = [median(corner5_x), median(corner5_y)];
    coor_platform = [median(platform_x), median(platform_y)];
    coor_center = [median((corner1_x + corner4_x)/2), median((corner1_y + corner4_y)/2)];

    %boundary distance
    dis_corner14 = sqrt(sum((coor_corner1-coor_corner4).^2));
    dis_corner25 = sqrt(sum((coor_corner2-coor_corner5).^2));
    average_boundary = dis_corner14;%90cm

    %whether in the boundary and plots
    L = linspace(0, 2*pi, 100);
    platform_x = cos(L)'* average_boundary/18 + coor_platform(1);
    platform_y = sin(L)'* average_boundary/18 + coor_platform(2);
    center_x = cos(L)'* average_boundary/2 + coor_center(1);
    center_y = sin(L)'* average_boundary/2 + coor_center(2);
    
    [THETA,RHO] = cart2pol(coor_platform(1)-coor_center(1),coor_platform(2)-coor_center(2));
    sector_start = round(THETA/pi*50-100/8);
    sector_start_all = sector_start:sector_start+100/4;
    sector_second_all = sector_start_all + 100/4;
    sector_third_all = sector_start_all + 2*100/4;
    sector_fourth_all = sector_start_all + 3*100/4;
    sector_start_all(sector_start_all<=0) =  sector_start_all(sector_start_all<=0)+100;
    sector_second_all(sector_second_all<=0) =  sector_second_all(sector_second_all<=0)+100;
    sector_third_all(sector_third_all<=0) =  sector_third_all(sector_third_all<=0)+100;
    sector_fourth_all(sector_fourth_all<=0) =  sector_fourth_all(sector_fourth_all<=0)+100;
    
    sector_start_all(sector_start_all>100) =  sector_start_all(sector_start_all>100)-100;
    sector_second_all(sector_second_all>100) =  sector_second_all(sector_second_all>100)-100;
    sector_third_all(sector_third_all>100) =  sector_third_all(sector_third_all>100)-100;
    sector_fourth_all(sector_fourth_all>100) =  sector_fourth_all(sector_fourth_all>100)-100;
    
    tarq_x = [coor_center(1); center_x(sector_start_all);coor_center(1)];
    tarq_y = [coor_center(2); center_y(sector_start_all); coor_center(2)];
    secq_x = [coor_center(1); center_x(sector_second_all);coor_center(1)];
    secq_y = [coor_center(2); center_y(sector_second_all); coor_center(2)];
    thirdq_x = [coor_center(1); center_x(sector_third_all);coor_center(1)];
    thirdq_y = [coor_center(2); center_y(sector_third_all); coor_center(2)];
    fourq_x = [coor_center(1); center_x(sector_fourth_all);coor_center(1)];
    fourq_y = [coor_center(2); center_y(sector_fourth_all); coor_center(2)];
    
    in_platform = inpolygon(bodycenter_x, bodycenter_y, platform_x, platform_y);%1:in 0:out
    in_platform_nose = inpolygon(nose_x, nose_y, platform_x, platform_y);
    in_platform_back = inpolygon(back_x, back_y, platform_x, platform_y);
    in_platform_body = in_platform_nose + in_platform_back;
    in_platform_body(in_platform_body==2) = 1;
    
    in_tar = inpolygon(bodycenter_x, bodycenter_y, tarq_x, tarq_y);
    in_sec = inpolygon(bodycenter_x, bodycenter_y, secq_x, secq_y);
    in_thir = inpolygon(bodycenter_x, bodycenter_y, thirdq_x, thirdq_y);
    in_four = inpolygon(bodycenter_x, bodycenter_y, fourq_x, fourq_y);
    

    in_platform(1:16) = 0;
    in_platform_nose(1:16) = 0;
    in_platform_back(1:16) = 0;
    
    %trajectory length
    length_bodycenter_pieces = sqrt(diff(bodycenter_x).^2+diff(bodycenter_y).^2);
    length_bodycenter_pieces = [length_bodycenter_pieces; 0];
    length_bodycenter_pieces(find(length_bodycenter_pieces>50)) = median(length_bodycenter_pieces);
    length_bodycenter_pieces_in = length_bodycenter_pieces(in_platform);
    if size(bodycenter_x,1)>161
        length_bodycenter_pieces_10s = length_bodycenter_pieces(1:161);
    else
        length_bodycenter_pieces_10s = length_bodycenter_pieces;
    end
    length_bodycenter_pieces_out = length_bodycenter_pieces(~in_platform);
    length_bodycenter_10s = sum(length_bodycenter_pieces_10s);%pixel
    length_bodycenter_in = sum(length_bodycenter_pieces_in);%pixel
    length_bodycenter_out = sum(length_bodycenter_pieces_out);%pixel
    length_bodycenter_all = sum(length_bodycenter_pieces);%pixel
    length_bodycenter_pieces_real = length_bodycenter_pieces/average_boundary*90;%cm
    length_bodycenter_in_real = length_bodycenter_in/average_boundary*90;%cm
    length_bodycenter_10s_real = length_bodycenter_10s/average_boundary*90;%cm
    length_bodycenter_out_real = length_bodycenter_out/average_boundary*90;%cm
    length_bodycenter_all_real = length_bodycenter_all/average_boundary*90;%cm
    length_bodycenter_in_percent = length_bodycenter_in/length_bodycenter_all;
    length_bodycenter_in_realw = [length_bodycenter_in_realw; length_bodycenter_in_real];%cm
    length_bodycenter_10s_realw = [length_bodycenter_10s_realw; length_bodycenter_10s_real];%cm
    length_bodycenter_out_realw = [length_bodycenter_out_realw; length_bodycenter_out_real];%cm
    length_bodycenter_all_realw = [length_bodycenter_all_realw; length_bodycenter_all_real];%cm
    length_bodycenter_in_percentw = [length_bodycenter_in_percentw; length_bodycenter_in_percent];
    
    length_nose_pieces = sqrt(diff(nose_x).^2+diff(nose_y).^2);
    length_nose_pieces = [length_nose_pieces; 0];
    length_nose_pieces(find(length_nose_pieces>50)) = median(length_nose_pieces);
    length_nose_pieces_in = length_nose_pieces(in_platform_nose);
    length_nose_in = sum(length_nose_pieces_in);%pixel
    length_nose_all = sum(length_nose_pieces);%pixel
    length_nose_pieces_real = length_nose_pieces/average_boundary*90;%cm
    length_nose_in_real = length_nose_in/average_boundary*90;%cm
    length_nose_all_real = length_nose_all/average_boundary*90;%cm
    length_nose_in_percent = length_nose_in/length_nose_all;
    length_nose_in_realw = [length_nose_in_realw; length_nose_in_real];%cm
    length_nose_all_realw = [length_nose_all_realw; length_nose_all_real];%cm
    length_nose_in_percentw = [length_nose_in_percentw; length_nose_in_percent];
    
    %trajectory time
    time_total = numel(in_platform)/16;%s
    time_in = sum(in_platform)/16;%s    
    time_in_tar = sum(in_tar)/16;
    time_in_sec = sum(in_sec)/16;
    time_in_third = sum(in_thir)/16;
    time_in_four = sum(in_four)/16;
    find_platform_frame = find(diff(in_platform)==1);
    out_platform_frame = find(diff(in_platform)==-1);
    frame_to_platform = numel(in_platform);
    if contains(file_name{1,i},'ay 6')
        platform_min_time = 1;
    else
        platform_min_time = 48;
    end

    if size(out_platform_frame,1) > size(find_platform_frame,1)
        out_platform_frame(1) = [];
    end
    
    n = 1;
    while 1
        if isempty(find_platform_frame)
            time_find_platform = size(data.data,1)/16-1;
            frame_to_platform = numel(in_platform);
            break
        elseif isempty(out_platform_frame)
            time_find_platform = (find_platform_frame(n)+load_num)/16;
            frame_to_platform = find_platform_frame(n);
            break
        elseif out_platform_frame(n) - find_platform_frame(n) > platform_min_time  
            time_find_platform = (find_platform_frame(n)+load_num)/16;
            frame_to_platform = find_platform_frame(n);
            break
        elseif n == size(out_platform_frame, 1)
            if n== size(find_platform_frame, 1)
                time_find_platform = size(data.data,1)/16-1;
                frame_to_platform = numel(in_platform);
            else
                time_find_platform = (find_platform_frame(n+1)+load_num)/16;
                frame_to_platform = find_platform_frame(n+1);
            end
            break
        end
        n = n+1;
    end
    
    length_bodycenter_pieces_before = length_bodycenter_pieces(1:frame_to_platform);
    length_bodycenter_pieces_after = length_bodycenter_pieces(frame_to_platform:end);
    length_bodycenter_before = sum(length_bodycenter_pieces_before);%pixel
    length_bodycenter_after = sum(length_bodycenter_pieces_after);%pixel
    length_bodycenter_before_real = length_bodycenter_before/average_boundary*90;
    length_bodycenter_after_real = length_bodycenter_after/average_boundary*90;
    length_bodycenter_before_realw = [length_bodycenter_before_realw; length_bodycenter_before_real];
    length_bodycenter_after_realw = [length_bodycenter_after_realw; length_bodycenter_after_real];
    
    time_to_platform = [time_to_platform; time_find_platform];
    time_totalw = [time_totalw; time_total];%s
    time_video_all = [time_video_all; time_video];%s
    time_select_percent_all = [time_select_percent_all; time_total/time_video];% %
    time_inw = [time_inw; time_in];%s
    time_in_tarw = [time_in_tarw; time_in_tar];
    time_in_secw = [time_in_secw; time_in_sec];
    time_in_thirdw = [time_in_thirdw; time_in_third];
    time_in_fourw = [time_in_fourw; time_in_four];
    time_in_percent = [time_in_percent; time_in/time_total];
    time_still_bodycenter = [time_still_bodycenter; numel(find(length_bodycenter_pieces_out<1))/16];%s,definition
    time_before = frame_to_platform/16;
    time_after = time_total-frame_to_platform/16;
    time_beforew = [time_beforew, time_before];
    time_afterw = [time_afterw, time_after];
    
    time_nose_total = numel(in_platform_nose)/16;%s
    time_nose_in = sum(in_platform_nose)/16;%s
    
    find_platform_frame_nose = find(diff(in_platform_nose)==1);
    out_platform_frame_nose = find(diff(in_platform_nose)==-1);

    if size(out_platform_frame_nose,1) > size(find_platform_frame_nose,1)
        out_platform_frame_nose(1) = [];
    end
    
    n = 1;    
    while 1
        if isempty(find_platform_frame_nose)
            time_nose_find_platform = size(data.data,1)/16-1;
            break
        elseif isempty(out_platform_frame_nose)
            time_nose_find_platform = (find_platform_frame_nose(n)+load_num)/16;
            break
        elseif out_platform_frame_nose(n) - find_platform_frame_nose(n) > 48  
            time_nose_find_platform = (find_platform_frame_nose(n)+load_num)/16;
            break
        elseif n == size(out_platform_frame_nose, 1)
            if n== size(find_platform_frame_nose, 1)
                time_nose_find_platform = size(data.data,1)/16-1;
            else
                time_nose_find_platform = (find_platform_frame_nose(n+1)+load_num)/16;
            end
            break
        end
        n = n+1;
    end

    time_nose_to_platform = [time_nose_to_platform; time_nose_find_platform];
    time_nose_totalw = [time_nose_totalw; time_nose_total];%s
    time_nose_inw = [time_nose_inw; time_nose_in];%s
    time_nose_in_percent = [time_nose_in_percent; time_nose_in/time_nose_total];
    time_still_nose = [time_still_nose; numel(find(length_nose_pieces<1))/16];%s,definition

    %trajectory velocity
    velocity_total = length_bodycenter_all_real/time_total;%cm/s
    velocity_in = length_bodycenter_in_real/time_in;%cm/s
    velocity_out = length_bodycenter_out_real/(time_total-time_in);%cm/s
    velocity_totalw = [velocity_totalw; velocity_total];%cm/s
    velocity_inw = [velocity_inw; velocity_in];%cm/s
    velocity_outw = [velocity_outw; velocity_out];%cm/s
    velocity_in_percent = [velocity_in_percent; velocity_in/velocity_total];
    velocity_before = length_bodycenter_before_real/time_before;%cm/s
    velocity_after = length_bodycenter_after_real/time_after;%cm/s
    velocity_beforew = [velocity_beforew; velocity_before];
    velocity_afterw = [velocity_afterw; velocity_after];
    
    velocity_nose_total = length_nose_all_real/time_nose_total;%cm/s
    velocity_nose_in = length_nose_in_real/time_nose_in;%cm/s
    velocity_nose_totalw = [velocity_nose_totalw; velocity_nose_total];%cm/s
    velocity_nose_inw = [velocity_nose_inw; velocity_nose_in];%cm/s
    velocity_nose_in_percent = [velocity_nose_in_percent; velocity_nose_in/velocity_nose_total];

    %center entry/exit times
    center_entry_times = [center_entry_times; size(find(diff(in_platform)==1),1)];
    center_exit_times = [center_exit_times; size(find(diff(in_platform)==-1),1)];
    center_entry_times_nose = [center_entry_times_nose; size(find(diff(in_platform_nose)==1),1)];
    center_exit_times_nose = [center_exit_times_nose; size(find(diff(in_platform_nose)==-1),1)];

    %body length
    length_nose_center_pieces = sqrt((nose_x - bodycenter_x).^2+(nose_y - bodycenter_y).^2);%pixel
    length_back_center_pieces = sqrt((back_x - bodycenter_x).^2+(back_y - bodycenter_y).^2);%pixel
    length_nose_back_pieces = sqrt((nose_x - back_x).^2+(nose_y - back_y).^2);%pixel
    length_nose_center_pieces(find(length_nose_center_pieces>50)) = median(length_nose_center_pieces);
    length_back_center_pieces(find(length_back_center_pieces>50)) = median(length_back_center_pieces);
    length_body_real = [length_body_real; mean((length_nose_center_pieces + length_back_center_pieces)/average_boundary*90)];%cm

    %body rotation
    rot_body_x = nose_x - back_x;
    rot_body_y = nose_y - back_y;
    rot_body_trajectory_pieces = sqrt(diff(rot_body_x).^2+diff(rot_body_y).^2);%pixel
    rot_body_trajectory_pieces = [rot_body_trajectory_pieces; 0];
    rot_body_x(find(rot_body_trajectory_pieces>50)) = [];
    rot_body_y(find(rot_body_trajectory_pieces>50)) = [];
    rot_body_trajectory_pieces(find(rot_body_trajectory_pieces>50)) = median(rot_body_trajectory_pieces);
    rot_body_angle_pieces = rot_body_trajectory_pieces./length_nose_back_pieces;
    rot_body_trajectory = sum(rot_body_trajectory_pieces);%pixel
    rot_body_angle = sum(rot_body_angle_pieces);%pixel
    rot_body_anglew = [rot_body_anglew; rot_body_angle];
    rot_body_trajectory_real = rot_body_trajectory/average_boundary*90;%cm
    rot_body_trajectory_realw = [rot_body_trajectory_realw; rot_body_trajectory_real];%cm
    rot_body_velocity = [rot_body_velocity; rot_body_trajectory_real/time_total];%cm/s
    time_still_body_rotation = [time_still_body_rotation; numel(find(rot_body_trajectory_pieces<1))/16];%s 直行或静止（身体不转）
    time_still_body_velocity_rotation = [time_still_body_velocity_rotation; numel(find(rot_body_trajectory_pieces<1 & length_bodycenter_pieces<1))/16];%s 真正静止
    
    rot_body_x_norm_sort = sort(abs(rot_body_x));
    rot_body_y_norm_sort = sort(abs(rot_body_y));
    rot_body_x_norm = rot_body_x/rot_body_x_norm_sort(end-5);
    rot_body_y_norm = rot_body_y/rot_body_y_norm_sort(end-5);

    rot_body_mid_up = find(-0.5<rot_body_x_norm & rot_body_x_norm<0.5 & rot_body_y_norm>0);
    if ~isempty(rot_body_mid_up)
        rot_body_mid_up(end) = [];
    end
    rot_body_mid_up_y = rot_body_x_norm(rot_body_mid_up+1)-rot_body_x_norm(rot_body_mid_up);
    clock_mid_up = rot_body_mid_up(find(rot_body_mid_up_y>0));
    clock_anti_mid_up = rot_body_mid_up(find(rot_body_mid_up_y<0));
    
    rot_body_mid_down = find(-0.5<rot_body_x_norm & rot_body_x_norm<0.5 & rot_body_y_norm<0);
    if ~isempty(rot_body_mid_down)
        rot_body_mid_down(end) = [];
    end
    rot_body_mid_down_y = rot_body_x_norm(rot_body_mid_down+1)-rot_body_x_norm(rot_body_mid_down);
    clock_mid_down = rot_body_mid_down(find(rot_body_mid_down_y<0));
    clock_anti_mid_down = rot_body_mid_down(find(rot_body_mid_down_y>0));
    
    rot_body_left = find(-0.5>rot_body_x_norm);
    if ~isempty(rot_body_left)
        rot_body_left(end) = [];
    end
    rot_body_left_y = rot_body_y_norm(rot_body_left+1)-rot_body_y_norm(rot_body_left);
    clock_left = rot_body_left(find(rot_body_left_y>0));
    clock_anti_left = rot_body_left(find(rot_body_left_y<0));
    
    rot_body_right = find(0.5<rot_body_x_norm);
    if ~isempty(rot_body_right)
        rot_body_right(end) = [];
    end
    rot_body_right_y = rot_body_y_norm(rot_body_right+1)-rot_body_y_norm(rot_body_right);
    clock_anti_right = rot_body_right(find(rot_body_right_y>0));
    clock_right = rot_body_right(find(rot_body_right_y<0));
    
    clock_all = sort([clock_left; clock_mid_up; clock_right; clock_mid_down]);
    clock_anti_all = sort([clock_anti_left; clock_anti_mid_up; clock_anti_right; clock_anti_mid_down]);
    rot_body_x_clock = rot_body_x(clock_all);
    rot_body_y_clock = rot_body_y(clock_all);
    rot_body_x_clock_anti = rot_body_x(clock_anti_all);
    rot_body_y_clock_anti = rot_body_y(clock_anti_all);
    
    rot_body_angle_clock_anti = sum(rot_body_angle_pieces(clock_anti_all));
    rot_body_angle_clock = sum(rot_body_angle_pieces(clock_all));
    rot_body_angle_pieces_plot = rot_body_angle_pieces;
    rot_body_angle_pieces_plot(clock_all) = -rot_body_angle_pieces_plot(clock_all);
    rot_body_angle_cum = cumsum(rot_body_angle_pieces_plot);
    rot_body_plot{i} = rot_body_angle_cum;
   
    rot_body_trajectory_clock_anti = sum(rot_body_trajectory_pieces(clock_anti_all));
    rot_body_trajectory_clock = sum(rot_body_trajectory_pieces(clock_all));
    rot_body_angle_rate = min(rot_body_angle_clock, rot_body_angle_clock_anti)/max(rot_body_angle_clock, rot_body_angle_clock_anti);
    rot_body_angle_abs = abs(rot_body_angle_clock-rot_body_angle_clock_anti);
    rot_body_trajectory_rate = min(rot_body_trajectory_clock, rot_body_trajectory_clock_anti)/max(rot_body_trajectory_clock, rot_body_trajectory_clock_anti);
    rot_body_trajectory_abs = abs(rot_body_trajectory_clock-rot_body_trajectory_clock_anti);
    rot_body_time_rate = min(size(clock_anti_all,1), size(clock_all,1))/max(size(clock_anti_all,1), size(clock_all,1));
    rot_body_angle_absw = [rot_body_angle_absw; rot_body_angle_abs];
    rot_body_angle_ratew = [rot_body_angle_ratew; rot_body_angle_rate];
    rot_body_trajectory_absw = [rot_body_trajectory_absw; rot_body_trajectory_abs];
    rot_body_trajectory_ratew = [rot_body_trajectory_ratew; rot_body_trajectory_rate];
    rot_body_time_ratew = [rot_body_time_ratew; rot_body_time_rate];
    
    rot_body_trajectory_pieces_before = rot_body_trajectory_pieces(1:frame_to_platform);
    rot_body_trajectory_pieces_after = rot_body_trajectory_pieces(frame_to_platform:end);
    rot_body_trajectory_before = sum(rot_body_trajectory_pieces_before);
    rot_body_trajectory_after = sum(rot_body_trajectory_pieces_after);
    rot_body_trajectory_before_real = rot_body_trajectory_before/average_boundary*90;
    rot_body_trajectory_after_real = rot_body_trajectory_after/average_boundary*90;
    rot_body_trajectory_before_realw = [rot_body_trajectory_before_realw; rot_body_trajectory_before_real];
    rot_body_trajectory_after_realw = [rot_body_trajectory_after_realw; rot_body_trajectory_after_real];
    rot_body_velocity_before = [rot_body_velocity_before; rot_body_trajectory_before_real/time_before];%cm/s
    rot_body_velocity_after = [rot_body_velocity_after; rot_body_trajectory_after_real/time_after];%cm/s
    
    
    %tail length
    length_back_middle_pieces = sqrt((back_x - tail_middle_x).^2+(back_y - tail_middle_y).^2);%pixel
    length_middle_end_pieces = sqrt((tail_middle_x - tail_end_x).^2+(tail_middle_y - tail_end_y).^2);%pixel
    length_back_end_pieces = sqrt((back_x - tail_end_x).^2+(back_y - tail_end_y).^2);%pixel
    length_back_middle_pieces(find(length_back_middle_pieces>50)) = median(length_back_middle_pieces);
    length_middle_end_pieces(find(length_middle_end_pieces>50)) = median(length_middle_end_pieces);
    length_tail_real = [length_tail_real; mean((length_back_middle_pieces + length_middle_end_pieces)/average_boundary*90)];%cm

    %tail rotation
    rot_tail_end_x = tail_end_x - back_x;
    rot_tail_end_y = tail_end_y - back_y;
    rot_tail_middle_x = tail_middle_x - back_x;
    rot_tail_middle_y = tail_middle_y - back_y;
    rot_tail_trajectory_pieces = sqrt(diff(rot_tail_end_x).^2+diff(rot_tail_end_y).^2);%pixel
    rot_tail_trajectory_pieces = [rot_tail_trajectory_pieces; 0];
    rot_tail_trajectory_pieces(find(rot_tail_trajectory_pieces>50)) = median(rot_tail_trajectory_pieces);
    rot_tail_angle_pieces = [rot_tail_trajectory_pieces./length_back_end_pieces];
    rot_tail_trajectory = sum(rot_tail_trajectory_pieces);%pixel
    rot_tail_angle = sum(rot_tail_angle_pieces);%pixel
    rot_tail_trajectory_real = rot_tail_trajectory/average_boundary*90;%cm
    rot_tail_anglew = [rot_tail_anglew; rot_tail_angle];%cm
    rot_tail_trajectory_realw = [rot_tail_trajectory_realw; rot_tail_trajectory_real];%cm
    rot_tail_velocity = [rot_tail_velocity; rot_tail_trajectory_real/time_total];%cm/scoor_corner5
    time_still_tail_rotation = [time_still_tail_rotation; numel(find(rot_tail_trajectory_pieces<1))/16];
    time_still_tail_velocity_rotation = [time_still_tail_velocity_rotation; numel(find(rot_tail_trajectory_pieces<1 & length_bodycenter_pieces<1))/16];
    
    rot_tail_x_norm_sort = sort(abs(rot_tail_end_x));
    rot_tail_y_norm_sort = sort(abs(rot_tail_end_y));
    rot_tail_x_norm = rot_tail_end_x/rot_tail_x_norm_sort(end-5);
    rot_tail_y_norm = rot_tail_end_y/rot_tail_y_norm_sort(end-5);

    rot_tail_mid_up = find(-0.5<rot_tail_x_norm & rot_tail_x_norm<0.5 & rot_tail_y_norm>0);
    if ~isempty(rot_tail_mid_up)
        rot_tail_mid_up(end) = [];
    end
    rot_tail_mid_up_y = rot_tail_x_norm(rot_tail_mid_up+1)-rot_tail_x_norm(rot_tail_mid_up);
    clock_mid_up = rot_tail_mid_up(find(rot_tail_mid_up_y>0));
    clock_anti_mid_up = rot_tail_mid_up(find(rot_tail_mid_up_y<0));
    
    rot_tail_mid_down = find(-0.5<rot_tail_x_norm & rot_tail_x_norm<0.5 & rot_tail_y_norm<0);
    if ~isempty(rot_tail_mid_down)
        rot_tail_mid_down(end) = [];
    end
    rot_tail_mid_down_y = rot_tail_x_norm(rot_tail_mid_down+1)-rot_tail_x_norm(rot_tail_mid_down);
    clock_mid_down = rot_tail_mid_down(find(rot_tail_mid_down_y<0));
    clock_anti_mid_down = rot_tail_mid_down(find(rot_tail_mid_down_y>0));
    
    rot_tail_left = find(-0.5>rot_tail_x_norm);
    if ~isempty(rot_tail_left)
        rot_tail_left(end) = [];
    end
    rot_tail_left_y = rot_tail_y_norm(rot_tail_left+1)-rot_tail_y_norm(rot_tail_left);
    clock_left = rot_tail_left(find(rot_tail_left_y>0));
    clock_anti_left = rot_tail_left(find(rot_tail_left_y<0));
    
    rot_tail_right = find(0.5<rot_tail_x_norm);
    if ~isempty(rot_tail_right)
        rot_tail_right(end) = [];
    end
    rot_tail_right_y = rot_tail_y_norm(rot_tail_right+1)-rot_tail_y_norm(rot_tail_right);
    clock_anti_right = rot_tail_right(find(rot_tail_right_y>0));
    clock_right = rot_tail_right(find(rot_tail_right_y<0));
    
    clock_all = sort([clock_left; clock_mid_up; clock_right; clock_mid_down]);
    clock_anti_all = sort([clock_anti_left; clock_anti_mid_up; clock_anti_right; clock_anti_mid_down]);
    rot_tail_x_clock = rot_tail_end_x(clock_all);
    rot_tail_y_clock = rot_tail_end_y(clock_all);
    rot_tail_x_clock_anti = rot_tail_end_x(clock_anti_all);
    rot_tail_y_clock_anti = rot_tail_end_y(clock_anti_all);
    
    rot_tail_angle_clock_anti = sum(rot_tail_angle_pieces(clock_anti_all));
    rot_tail_angle_clock = sum(rot_tail_angle_pieces(clock_all));
    rot_tail_angle_pieces_plot = rot_tail_angle_pieces;
    rot_tail_angle_pieces_plot(clock_all) = -rot_tail_angle_pieces_plot(clock_all);
    rot_tail_angle_cum = cumsum(rot_tail_angle_pieces_plot);
    rot_tail_plot{i} = rot_tail_angle_cum;
    rot_tail_trajectory_clock_anti = sum(rot_tail_trajectory_pieces(clock_anti_all));
    rot_tail_trajectory_clock = sum(rot_tail_trajectory_pieces(clock_all));
    rot_tail_angle_rate = min(rot_tail_angle_clock, rot_tail_angle_clock_anti)/max(rot_tail_angle_clock, rot_tail_angle_clock_anti);
    rot_tail_angle_abs = abs(rot_tail_angle_clock-rot_tail_angle_clock_anti);
    rot_tail_trajectory_rate = min(rot_tail_trajectory_clock, rot_tail_trajectory_clock_anti)/max(rot_tail_trajectory_clock, rot_tail_trajectory_clock_anti);
    rot_tail_trajectory_abs = abs(rot_tail_trajectory_clock-rot_tail_trajectory_clock_anti);
    rot_tail_time_rate = min(size(clock_anti_all,1), size(clock_all,1))/max(size(clock_anti_all,1), size(clock_all,1));
    rot_tail_angle_absw = [rot_tail_angle_absw; rot_tail_angle_abs];
    rot_tail_angle_ratew = [rot_tail_angle_ratew; rot_tail_angle_rate];
    rot_tail_trajectory_absw = [rot_tail_trajectory_absw; rot_tail_trajectory_abs];
    rot_tail_trajectory_ratew = [rot_tail_trajectory_ratew; rot_tail_trajectory_rate];
    rot_tail_time_ratew = [rot_tail_time_ratew; rot_tail_time_rate];
    
    rot_tail_trajectory_pieces_before = rot_tail_trajectory_pieces(1:frame_to_platform);
    rot_tail_trajectory_pieces_after = rot_tail_trajectory_pieces(frame_to_platform:end);
    rot_tail_trajectory_before = sum(rot_tail_trajectory_pieces_before);
    rot_tail_trajectory_after = sum(rot_tail_trajectory_pieces_after);
    rot_tail_trajectory_before_real = rot_tail_trajectory_before/average_boundary*90;
    rot_tail_trajectory_after_real = rot_tail_trajectory_after/average_boundary*90;
    rot_tail_trajectory_before_realw = [rot_tail_trajectory_before_realw; rot_tail_trajectory_before_real];
    rot_tail_trajectory_after_realw = [rot_tail_trajectory_after_realw; rot_tail_trajectory_after_real];
    rot_tail_velocity_before = [rot_tail_velocity_before; rot_tail_trajectory_before_real/time_before];%cm/s
    rot_tail_velocity_after = [rot_tail_velocity_after; rot_tail_trajectory_after_real/time_after];%cm/s
    
    dis_middle = sqrt((rot_tail_middle_x).^2+(rot_tail_middle_y).^2);
    cos_rot = rot_tail_middle_x ./ dis_middle;
    sin_rot = rot_tail_middle_y ./ dis_middle;
    
    for j = 1:numel(in_platform) %tip rotation
        norm_tail_middle_x(j) = rot_tail_middle_x(j) * cos_rot(j) + rot_tail_middle_y(j) * sin_rot(j);
        norm_tail_middle_y(j) = -rot_tail_middle_x(j) * sin_rot(j) + rot_tail_middle_y(j) * cos_rot(j);
        norm_tail_end_x(j) = rot_tail_end_x(j) * cos_rot(j) + rot_tail_end_y(j) * sin_rot(j);
        norm_tail_end_y(j) = -rot_tail_end_x(j) * sin_rot(j) + rot_tail_end_y(j) * cos_rot(j);
    end
    norm_tail_end_y_before = norm_tail_end_y(1:frame_to_platform);
    norm_tail_end_y_after = norm_tail_end_y(frame_to_platform:end);
    
    cross_times = 0;
    for k = 1:numel(in_platform)-1
        if norm_tail_end_y(k) * norm_tail_end_y(k+1)<0
            cross_times = cross_times + 1;
        end
    end
    
    cross_times_before = 0;
    for k = 1:size(norm_tail_end_y_before,2)-1
        if norm_tail_end_y_before(k) * norm_tail_end_y_before(k+1)<0
            cross_times_before = cross_times_before + 1;
        end
    end
    
    cross_times_after = 0;
    for k = 1:size(norm_tail_end_y_after,2)-1
        if norm_tail_end_y_after(k) * norm_tail_end_y_after(k+1)<0
            cross_times_after = cross_times_after + 1;
        end
    end

    swing_times = numel(findpeaks(norm_tail_end_y));%swing times
    if size(norm_tail_end_y_before, 2)<3
        swing_times_before = 0;
    else
        swing_times_before = numel(findpeaks(norm_tail_end_y_before));
    end
    if size(norm_tail_end_y_after, 2)<3
        swing_times_after = 0;
    else
        swing_times_after = numel(findpeaks(norm_tail_end_y_after));
    end
    
    swing_cross_times = cross_times/2;
    swing_cross_times_before = cross_times_before/2;
    swing_cross_times_after = cross_times_after/2;
    swing_frequency = swing_times/(time_total-time_in);
    swing_frequency_before = swing_times_before/time_before;
    swing_frequency_after = swing_times_after/time_after;
    swing_cross_frequency = swing_cross_times/(time_nose_total-time_nose_in);
    swing_cross_frequency_before = swing_cross_times_before/time_before;
    swing_cross_frequency_after = swing_cross_times_after/time_after;
    swing_frequencyw = [swing_frequencyw; swing_frequency];
    swing_frequency_beforew = [swing_frequency_beforew; swing_frequency_before];
    swing_frequency_afterw = [swing_frequency_afterw; swing_frequency_after];
    swing_cross_frequencyw = [swing_cross_frequencyw; swing_cross_frequency];
    swing_cross_frequency_beforew = [swing_cross_frequency_beforew; swing_cross_frequency_before];
    swing_cross_frequency_afterw = [swing_cross_frequency_afterw; swing_cross_frequency_after];
    norm_tail_middle_x = [];
    norm_tail_middle_y = [];
    norm_tail_end_x = [];
    norm_tail_end_y = [];
    norm_tail_end_y_before = [];
    norm_tail_end_y_after = [];
    
    maze_center_strategy = (coor_corner1+coor_corner4)/2/dis_corner14*90;
    platform_strategy = coor_platform/dis_corner14*90-maze_center_strategy;
    bodycenter_strategy = [bodycenter_x, bodycenter_y]/dis_corner14*90 - maze_center_strategy;
    time_bodycenter =  1/16:1/16:size(bodycenter_strategy,1)/16;
    write_strategy = [0,platform_strategy;time_bodycenter', bodycenter_strategy];

    csvwrite([strategy_dir,file_name{i},'.csv'], write_strategy)

end

varNames = {'filename', 'trial_name', 'time_video', 'time_total', 'time_selected_percent', 'time_to_platform', 'time_in_platform', 'time_in_percent',... 
    'time_nose_to_platform', 'time_nose_in_platform', 'time_nose_in_percent','trajectory_length_bodycenter',...
    'trajectory_length_bodycenter_in', 'trajectory_length_bodycenter_in_percent', 'trajectory_length_nose',...
    'trajectory_length_nose_in', 'trajectory_length_nose_in_percent','time_still_bodycenter', 'time_still_nose',...
    'velocity_total','velocity_in','velocity_in_percent','velocity_nose_total','velocity_nose_in','velocity_nose_in_percent',...
    'platform_entry_times','platform_exit_times','platform_nose_entry_times','platform_nose_exit_times','body_length',...
    'body_rotation_trajectory', 'body_rotation_velocity',...
    'time_body_rotation_still', 'time_body_velocity_rotation_still','tail_length','tail_rotation_trajectory', ...
    'tail_rotation_velocity', 'time_tail_rotation_still', 'time_tail_velocity_rotation_still',...
    'tail_swing_frequency', 'tail_swing_cross_frequency', 'trajectory_length_bodycenter_out', 'velocity_out',...
    'trajectory_length_bodycenter_before', 'trajectory_length_bodycenter_after', 'velocity_before', 'velocity_after',...
    'tail_rotation_trajectory_before', 'tail_rotation_trajectory_after', 'tail_rotation_velocity_before', 'tail_rotation_velocity_after'...
    'body_rotation_trajectory_before', 'body_rotation_trajectory_after','body_rotation_velocity_before', 'body_rotation_velocity_after','time_before', 'time_after',...
    'tail_swing_frequency_before', 'tail_swing_frequency_after','tail_swing_cross_frequency_before', 'tail_swing_cross_frequency_after', 'trajectory_length_10s',...
    'rot_body_trajectory_abs', 'rot_body_trajectory_rate', 'rot_body_time_rate','rot_tail_trajectory_abs', 'rot_tail_trajectory_rate', 'rot_tail_time_rate'...
    'rot_body_angle', 'rot_tail_angle', 'rot_body_angle_absw', 'rot_body_angle_ratew', 'rot_tail_angle_absw', 'rot_tail_angle_ratew'...
     'time_in_tarw', 'time_in_secw', 'time_in_thirdw', 'time_in_fourw'};
features = table(file_name', trial_name, time_video_all, time_totalw, time_select_percent_all, time_to_platform, time_inw, time_in_percent,...
    time_nose_to_platform, time_nose_inw, time_nose_in_percent, length_bodycenter_all_realw,...
    length_bodycenter_in_realw, length_bodycenter_in_percentw, length_nose_in_realw, length_nose_all_realw, ...
    length_nose_in_percentw, time_still_bodycenter, time_still_nose, velocity_totalw, velocity_inw,...
    velocity_in_percent, velocity_nose_totalw, velocity_nose_inw, velocity_nose_in_percent, center_entry_times,...
    center_exit_times, center_entry_times_nose, center_exit_times_nose, length_body_real, rot_body_trajectory_realw, ...
    rot_body_velocity, time_still_body_rotation,...
    time_still_body_velocity_rotation, length_tail_real, rot_tail_trajectory_realw, rot_tail_velocity, ...
    time_still_tail_rotation, time_still_tail_velocity_rotation, swing_frequencyw, swing_cross_frequencyw, ...
    length_bodycenter_out_realw, velocity_outw, length_bodycenter_before_realw, length_bodycenter_after_realw, velocity_beforew, velocity_afterw,...
    rot_tail_trajectory_before_realw, rot_tail_trajectory_after_realw, rot_tail_velocity_before, rot_tail_velocity_after,...
    rot_body_trajectory_before_realw, rot_body_trajectory_after_realw, rot_body_velocity_before, rot_body_velocity_after, time_beforew', time_afterw', ...
    swing_frequency_beforew, swing_frequency_afterw, swing_cross_frequency_beforew, swing_cross_frequency_afterw, length_bodycenter_10s_realw, ...
    rot_body_trajectory_absw, rot_body_trajectory_ratew, rot_body_time_ratew,rot_tail_trajectory_absw, rot_tail_trajectory_ratew, rot_tail_time_ratew,...
    rot_body_anglew, rot_tail_anglew, rot_body_angle_absw, rot_body_angle_ratew, rot_tail_angle_absw, rot_tail_angle_ratew, ...
    time_in_tarw, time_in_secw, time_in_thirdw, time_in_fourw, 'VariableNames',varNames);
writetable(features, writing_dir);

