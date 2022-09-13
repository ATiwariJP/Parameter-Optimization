function f = objectiveFcnSim_ATJP(k)
            
            assignin('base','k',k);
            sim('TWIN.slx'); 

%             X2 = evalin('base','X2'); Y2 = evalin('base','Y2');
%             X1 = evalin('base','X1'); Y1 = evalin('base','Y1');
%             
            plot(Y1); hold on;

            % Store the values of k in the subsequent iterations
            temp_iter = evalin('base','temp_iter'); 
            temp_iter = [temp_iter; k];
            assignin('base','temp_iter',temp_iter); 

            frequency_heart = evalin('base','frequency_heart');
            
            MSE_X = mean((X1-X2).^2);
            MSE_Y = mean((Y1-Y2).^2);  
            MSE = MSE_X + MSE_Y;
            
            MOSC_updates;
            disp(strcat("check:",string(sum(X1))))

            assignin('base','w1b',w1b);
            assignin('base','w2b',w2b); 
            assignin('base','w3b',w3b);
            assignin('base','w4b',w4b);

            f = MSE;
   
end