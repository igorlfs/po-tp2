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

    total_cost = 0
    for (i, d) in enumerate(demand)
        cost_produce_today = cost[i]
        min_cost_stock = typemax(Float64)
        for j in 1:i-1
            cost_stock = cost[j] + sum(storage[k] for k in j:i-1)
            if cost_stock < min_cost_stock
                min_cost_stock = cost_stock
            end
        end
        min_cost_penalty = typemax(Float64)
        for j in i+1:horizon
            cost_penanlty = cost[j] + sum(penalty[k] for k in i:j-1)
            if cost_penanlty < min_cost_penalty
                min_cost_penalty = cost_penanlty
            end
        end
        total_cost += d * minimum([cost_produce_today, min_cost_stock, min_cost_penalty])
    end

    println("TP2 $MATRÍCULA = $total_cost")
end

main()
