# Hestia is a registered Julia package
# Add Hestia.jl to your enviroment
# julia> ]
# pkg> add Hestia 

using Hestia
λ = [10.0, 0.2, -0.0001]  # Thermal conductivity: λ(T) = 10 + 0.2 T - 1e-4 T^2
ρ = [7800.0]     # Mass density: constant
c = [330.0, 0.4] # Specific heat capacity: c(T) = 330 + 0.4 T

L = 0.3    # Length
W = 0.2    # Width    
H = 0.1    # Height

Nx = 40     # Number of elements: x direction
Ny = 24     # Number of elements: y direction
Nz = 10
Ntotal = Nx*Ny*Nz

property = createDynamicIsoProperty(λ, ρ, c)
cuboid   = HeatCuboid(L, W, H,Nx, Ny, Nz, property)

### Boundaries ###
boundary = initBoundary(cuboid)

h = 10.0 # heat transfer coefficient
ϵ = 0.6  # emissivity
θamb = 300.0; # Ambient temperature
emission1 = createEmission(h, ϵ, θamb)  # Nonlinear BC: heat transfer (linear) and heat radiation (quartic/nonlinear)
emission2 = createEmission(h, 0.0, θamb) 

setEmission!(boundary, emission1, :west) # Add emission to boundary
setEmission!(boundary, emission1, :east )
setEmission!(boundary, emission2, :north )
setEmission!(boundary, emission2, :topside)


# HeatProblem = container for geometry and boundary (not necessary)
# const heatproblem = CubicHeatProblem(cuboid, boundary)


## Simulation of cooling-down process ##
#=
cooling_down!(dθ, θ, param, t) = diffusion!(dθ, θ, cuboid, property, boundary)

# Initial conditions of ODE
θ₀ = 600.0  # Initial temperature
θinit = θ₀*ones(Ntotal)
tspan = (0.0, 200.0)
Δt    = 0.2             # Sampling time

import OrdinaryDiffEq
prob_cool = OrdinaryDiffEq.ODEProblem(cooling_down!,θinit,tspan)
sol_cool = OrdinaryDiffEq.solve(prob_cool,OrdinaryDiffEq.Euler(), dt=Δt, save_everystep=false)  # saveat=1.0)
=#

## Heating-up process ##
## Actuation ##
num_actuators = (4,3)        # Number of actuators
pos_actuators = :underside   # Position of actuators
actuation     = initActuation(cuboid)

# Create actuator characterization
scale     = 1.0;
power     = 3 
curvature = 100.0;

config1  = setConfiguration(1.0, 3, 50)
config2  = setConfiguration(0.5, 2, 30)

setActuation!(actuation, cuboid, num_actuators, config1, :underside)

config_table = [config2 config1; 
                config2 config1]
partition = [13 15; 
             14  0]

#=
Partition on boundary east
x₃
^
| 15 |  0 |
|-------------
| 13 | 14 | 
|------------> x₂
=#

setActuation!(actuation, cuboid, partition, config_table, :east)

num_act_total = num_actuators[1]*num_actuators[2] + 3
u_in = 4e5 * ones(num_act_total)

heating_up!(dθ, θ, param, t) = diffusion!(dθ, θ, cuboid, property, boundary, actuation, u_in)

## Simulation of heating-up process
# Initial conditions of ODE
θ₀ = 300.0  # Initial temperature
θinit = θ₀*ones(Ntotal)
tspan = (0.0, 200.0)
Δt    = 0.2  # Sampling time


import OrdinaryDiffEq

prob_heating = OrdinaryDiffEq.ODEProblem(heating_up!,θinit,tspan)
sol_heating  = OrdinaryDiffEq.solve(prob_heating,OrdinaryDiffEq.Euler(), dt=Δt, save_everystep=false) 