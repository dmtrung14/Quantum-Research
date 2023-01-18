using Plots
using BenchmarkTools
##
function bit_majority_voting(bit)
    one = 0
    zero = 0
    for i in bit
        if i == '1'
            one +=1
        
        else
            zero +=1
        end
    
    end
    if one > zero
        return "1"
    elseif zero > one
        return "0"
    end
end

function monte_carlo_code_simulation(repetition_code_size, error_rate)
    correct_results = 0
    for attempt_number in 1:100000
        all_zeroes_encoded_bit = repeat("0", repetition_code_size)        
        encoded_bit_after_noise = ""
        for attempt_number in 1:repetition_code_size
            random_number_generator = rand()
            if random_number_generator < error_rate
                encoded_bit_after_noise = encoded_bit_after_noise*"1"
            else
                encoded_bit_after_noise = encoded_bit_after_noise*"0"
            end
        end


        decoded_result = bit_majority_voting(encoded_bit_after_noise) #majority voting on how many bits were flipped
        

        if decoded_result == "0"
            correct_results +=1
        end

    end
    return correct_results/100000
end

# plotting decoding error rate vs physical error rate
function plotting_repetition_code(number_of_value_points)
    x = range(0,0.3,number_of_value_points)
    y1 = 1 .- monte_carlo_code_simulation.(6, x)
    y2 = 1 .- monte_carlo_code_simulation.(4, x)
    display(plot(x, [y1 y2 x]))
end

println(monte_carlo_code_simulation(4, 0.3))
plotting_repetition_code(20)
