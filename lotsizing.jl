const MATRÍCULA = "2020041973"

function read_horizon(file::IOStream, size::Int64)
    cost::Vector{Float64} = zeros(size)
    demand::Vector{Float64} = zeros(size)
    storage::Vector{Float64} = zeros(size)
    penalty::Vector{Float64} = zeros(size)
    for line in eachline(file)
        data = split(line, "\t")
        if data[1] == "c"
            cost[parse(Int64, data[2])] = parse(Float64, data[3])
        elseif data[1] == "d"
            demand[parse(Int64, data[2])] = parse(Float64, data[3])
        elseif data[1] == "s"
            storage[parse(Int64, data[2])] = parse(Float64, data[3])
        elseif data[1] == "p"
            penalty[parse(Int64, data[2])] = parse(Float64, data[3])
        end
    end
    return demand, cost, storage, penalty
end

function main()
    if length(ARGS) == 0
        return
    end

    input_file::IOStream = open(ARGS[1], "r")
    horizon::Int64 = parse(Int64, split(readline(input_file), "\t")[2])
    demand, cost, storage, penalty = read_horizon(input_file, horizon)
    prod_per_period = zeros(horizon)

    total_cost = 0
    for (i, d) in enumerate(demand)
        cost_produce_today = cost[i]

        current_cost = cost_produce_today
        min_stock_idx = 1
        min_penalty_idx = i + 1

        min_cost_stock = typemax(Float64)
        for j in 1:i-1
            cost_stock = cost[j] + sum(storage[k] for k in j:i-1)
            if cost_stock < min_cost_stock
                min_cost_stock = cost_stock
                min_stock_idx = j
            end
        end

        min_cost_penalty = typemax(Float64)
        for j in i+1:horizon
            cost_penanlty = cost[j] + sum(penalty[k] for k in i:j-1)
            if cost_penanlty < min_cost_penalty
                min_cost_penalty = cost_penanlty
                min_stock_idx = j
            end
        end

        if min_cost_stock < cost_produce_today && min_cost_stock < min_cost_penalty
            current_cost = min_cost_stock
            prod_per_period[min_stock_idx] += d
        elseif min_cost_penalty < cost_produce_today && min_cost_penalty < min_cost_stock
            current_cost = min_cost_penalty
            prod_per_period[min_penalty_idx] += d
        else
            prod_per_period[i] += d
        end

        total_cost += d * current_cost
    end

    # println(sum(prod_per_period) == sum(demand))

    println("TP2 $MATRÍCULA = $total_cost")
    for (_, c) in enumerate(prod_per_period)
        print("$c\t")
    end
    println()
end

main()
