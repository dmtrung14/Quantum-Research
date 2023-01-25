using Plots
function flip_i_bit(i, string)
    return string ⊻ 1 << (i-1)
    # so we don't need bitstring() to perform the xor bitflipping
    # return bitstring(string ⊻ 1 <<i)
    # # flip from right to left
end
function error_rate_without_correction(SAMPLE_SIZE, length, error_rate, string)
    error = 0
    for i in bitflip_generator(SAMPLE_SIZE, length, error_rate, string)
        if i != string
            error += 1
        end
    end
    return error/SAMPLE_SIZE
end
function bitflip_generator(SAMPLE_SIZE, length, error_rate, string)
    #for any codeword, generate a number of bitflips(or not) with probability of p.
    res = Int8[]
    for sample in 1:SAMPLE_SIZE
        codeword = string
        for i in 1:length
            p =rand()
            if p < error_rate
                codeword = flip_i_bit(i, codeword)
                # codeword = parse(UInt, flip_i_bit(i, codeword) ; base=2)
            end
        end
        push!(res, codeword)
        #add the last length digit of bitstring to the result
    end
    
    return res
end

function calculate_syndrome(H, x)
    m = size(H,1)
    res = 0
    
    for i in 1:m
        res_string = H[i] & x
        res = res << 1 + count_ones(res_string)%2
    end
    return res
end

#Creating a map of syndrome vs errors
function syndrome_key_map(H)
    hashmap = Dict()
    n = size(H,1)
    for i in 0:2^n
        if calculate_syndrome(H,i) ∉ keys(hashmap)
            hashmap[calculate_syndrome(H,i)] = Int8[]
            push!(hashmap[calculate_syndrome(H,i)], i)
        else 
            push!(hashmap[calculate_syndrome(H,i)], i)
        end
    end
    return hashmap
end


# Return an Array of all possible errors
function decode_syndrome(H,s)
    hashmap = syndrome_key_map(H)
    hashmap[s] = sort(hashmap[s], by=count_ones)
    return hashmap[s]
    # return an array
end

# Syndrome Decoding function
function syndrome_decoding(H, noisy_code_word)         
    syndrome = calculate_syndrome(H,noisy_code_word)
    decoded_logical_value = decode_syndrome(H, syndrome)[1] ⊻ noisy_code_word
    return decoded_logical_value
end


#Test
function monte_carlo_code_simulation(x)
    H = [0b110, 0b011]
    correct_codeword = 0b000
    correct = 0
    length = 100000
    for i in bitflip_generator(length, 3, x, correct_codeword)
        if syndrome_decoding(H,i) == correct_codeword
            correct +=1
        end
    end
    return correct/ length
end

#x = physical error rates, y: x= y ; simulated error_rate without correction; simulated logical error rate
function plotting_repetition_code(number_of_value_points)
    x = range(0,0.2,number_of_value_points)
    y1 = 1 .- monte_carlo_code_simulation.(x)
    z = error_rate_without_correction.(100000, 3, x, 0b000)
    display(plot(x, [y1 x z]))
end