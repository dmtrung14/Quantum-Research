function get_parity_check_matrix()
    print("n-k: ")
    x = parse(Int64, readline())
    print("n: ")
    y = parse(Int64, readline())
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
    res = zeros(n-k)
    for i in 1:n-k
        temp = 0
        for j in H[i,1:y]
            temp += x[i]*j
        end
        res[i] = temp
    end
    return res
end

function syndrome_key_map(H)
    hashmap = Dict()
    for i in 1:2^n
        t = digits(i, base =2, pad = trunc(Int, log2(i)))
        if calculate_syndrome(H,t) not in hashmap
            hashmap[calculate_syndrome(H,t)] = zeros(0)
            push!(hashmap[calculate_syndrome(H,t)], i)
        else 
            push!(hashmap[calculate_syndrome(H,t)], i)
        end
    end
    return hashmap
end

function decode_syndrome(x)
    hashmap = syndrome_key_map(H)
    return hashmap(calculate_syndrome(H,x))
end

H = get_parity_check_matrix()
TOTAL_SAMPLES = parse(Int32, readline())
noisy_code_word = readline()
for sample in 1:TOTAL_SAMPLES
    correct_answer =0 
    syndrome = calculate_syndrome(H,noisy_code_word)
    decoded_logical_value = decode_syndrome(syndrome)

    if decode_logical_value_is_correct
        correct_answer +=1
    end
end
