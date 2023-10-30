using Pkg;
Pkg.activate(".")
using JuMP, Random, GLPK

function guess_slope(order::Integer, num_points::Integer)

    x_rand = rand(Float64, num_points) .* 2.0 .- 1.0

    model = Model()
    set_optimizer(model, GLPK.Optimizer)

    #Define variables
    @variable(model, coeffs[i = 1:order])

    #Define Constraints
    for x_pt in x_rand
        constr_expr = sum([coeffs[i] * x_pt^(i - 1) for i = 1:order])
        @constraint(model, constr_expr <= 1)
        @constraint(model, constr_expr >= -1)
    end

    #Define Objective
    @objective(model, Max, coeffs[2])

    #Run the opimization
    optimize!(model)

    println("The guessed maximal slope is: ", objective_value(model))
end

guess_slope(parse(Int, ARGS[1]), parse(Int, ARGS[2]))
