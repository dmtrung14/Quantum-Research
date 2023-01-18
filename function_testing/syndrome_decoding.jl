function string_xor(a,b)
    res = zeros(Int8, 0)
    n = length(b)
    for i in 1:n
        push!(res, parse(Int8,a[i]) ⊻ parse(Int8, b[i]))
    end
    return join(res)
end
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
                temp ⊻= parse(Int, x[i]) * j
            else
                temp ⊻= trunc(Int, x[i]*j)
            end
        end
        res[i] = temp
    end
    return res
end

#Creating a map of syndrome vs errors
function syndrome_key_map(H)
    hashmap = Dict()
    n = size(H,1)
    for i in 1:2^n
        t = digits(i, base =2, pad = n+1)
        if calculate_syndrome(H,t) ∉ keys(hashmap)
            hashmap[calculate_syndrome(H,t)] = Int8[]
            push!(hashmap[calculate_syndrome(H,t)], i)
        else 
            push!(hashmap[calculate_syndrome(H,t)], i)
        end
    end
    return hashmap
end


# Return an Array of all possible errors
function decode_syndrome(H,s)
    hashmap = syndrome_key_map(H)
    return hashmap[s]
    # return an array
end

# Syndrome Decoding Test
function syndrome_decoding(TOTAL_SAMPLES, noisy_code_word, correct_code_word)
    H = get_parity_check_matrix(2,3)
    correct_answer = 0 
    for sample in 1:TOTAL_SAMPLES        
        syndrome = calculate_syndrome(H,noisy_code_word)
        decoded_logical_value = string_xor(bitstring(decode_syndrome(H, syndrome)[rand(1:length(decode_syndrome(H, syndrome)))]), noisy_code_word)
        # println(decoded_logical_value)
        if string(decoded_logical_value) == correct_code_word
            correct_answer +=1
        end
    end
    return correct_answer / TOTAL_SAMPLES
end