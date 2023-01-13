function get_parity_check_matrix(x,y)
    s = zeros(Int8, x,y)
    for i in 1:x
        for j in 1:y
            print("($i, $j) = ")
            s[i,j] = parse(Int8, readline())
        end
    end
    return s
end

function calculate_syndrome(H, x)
    # H = m*n parity check matrix
    m = size(H,1)
    n = size(H,2)
    res = zeros(m)
    for i in 1:m
        temp = 0
        for j in H[i,1:n]
            if typeof(x[i]) == Char
                temp += parse(Int, x[i]) * j
            else
                temp ⊻= x[i]*j
            end
        end
        res[i] = temp
    end
    return res
end

function syndrome_key_map(H)
    hashmap = Dict()
    n = size(H,1)
    for i in 1:2^n
        t = digits(i, base =2, pad = n+1)
        if calculate_syndrome(H,t) ∉ keys(hashmap)
            hashmap[calculate_syndrome(H,t)] = zeros(0)
            push!(hashmap[calculate_syndrome(H,t)], i)
        else 
            push!(hashmap[calculate_syndrome(H,t)], i)
        end
    end
    return hashmap
end

function decode_syndrome(H,s)
    hashmap = syndrome_key_map(H)
    return hashmap[calculate_syndrome(H,s)]
    # return an array
end

# Syndrome Decoding Test

function syndrome_decoding()
    H = get_parity_check_matrix(3,2)
    TOTAL_SAMPLES = parse(Int32, readline())
    noisy_code_word = readline()
    correct_code_word = readline()
    correct_answer = 0 
    for sample in 1:TOTAL_SAMPLES        
        syndrome = calculate_syndrome(H,noisy_code_word)
        decoded_logical_value = decode_syndrome(H, syndrome)[rand(1:length(decode_syndrome(H, syndrome)))]    
        if bitstring(decoded_logical_value) == correct_code_word
            correct_answer +=1
        end
    end
    return correct_answer / TOTAL_SAMPLES
end