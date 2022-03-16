using PlotlyJS
basepath        = "results/plots/";

x1span = range(0, stop=L, length=Nx)
x2span = range(0, stop=W, length=Ny)
x3span = range(0, stop=H, length=Nz)
X, Y, Z = mgrid(x1span, x2span, x3span)

values = reshape(sol_heating[end], Nx, Ny,Nz)


isomin_sol = 360
isomax_sol = round(Int,maximum(sol_heating[end]))

trace_cuboid = volume(
    x=X[:],
    y=Y[:],
    z=Z[:],
    value=values[:],
    isomin=isomin_sol,
    isomax=isomax_sol,
    opacity=0.2, # needs to be small to see through all surfaces
    surface_count=20, # needs to be a large number for good volume rendering
    #colorbar=attr(;title="Temperature [K]", titleside="right", titlefont=attr(;size=20))
    showscale=false,
)

layout_cuboid = Layout( scene_camera = attr(
                           #up = attr(x=0, y=0, z=1),
                           #center =  attr(x=0.15, y=0.1, z=0.05),
                           eye = attr(x=-1.7, y=-1.7, z=1.),), 
                        scene = attr(  
                           xaxis = attr(; title="Length", titlefont=attr(; size=20)) ,
                           yaxis = attr(;title="Width", titlefont=attr(; size=20)) ,
                           zaxis = attr(;title="Heigth", titlefont=attr(; size=20)),
                           ));



cuboid_plot = plot(trace_cuboid, layout_cuboid)
path_cuboid_str = basepath * "cuboid_3d_heating.pdf"
PlotlyJS.savefig(cuboid_plot,path_cuboid_str)


temperature_east = values[Nx,:,:]'
data_east    = contour(; x=x2span, y=x3span, z=temperature_east, colorbar=attr(;title="Temperature [K]", titleside="right", titlefont=attr(;size=20)))
layout_east  = Layout(; xaxis = attr(; title="Width [m]", titlefont=attr(; size=20) ) ,yaxis=attr(;title="Heigth [m]", titlefont=attr(; size=20)) )
temperature_east_plot = plot(data_east, layout_east)

path_east_str = basepath * "cuboid_east_heating.pdf"
PlotlyJS.savefig(temperature_east_plot,path_east_str)

temperature_underside = values[:,:,1]'
data_underside    = contour(; x=x1span, y=x2span, z=temperature_underside, colorbar=attr(;title="Temperature [K]", titleside="right", titlefont=attr(;size=20)))
layout_underside  = Layout(; xaxis = attr(; title="Length [m]", titlefont=attr(; size=20) ) ,yaxis=attr(;title="Width [m]", titlefont=attr(; size=20)) )
temperature_underside_plot = Plot(data_underside, layout_underside)

path_underside_str = basepath * "cuboid_underside_heating.pdf"
PlotlyJS.savefig(temperature_underside_plot,path_underside_str)


char_east, indx_east = checkActuation2D(actuation, cuboid, :east)
character_east = char_east'
data_char_east    = contour(; x=x2span, y=x3span, z=character_east, colorbar=attr(;title="Scaling", titleside="right", titlefont=attr(;size=20)))
layout_char_east  = Layout(; xaxis = attr(; title="Width [m]", titlefont=attr(; size=20) ) ,yaxis=attr(;title="Heigth [m]", titlefont=attr(; size=20)) )

char_east_plot = plot(data_char_east, layout_char_east)

path_char_east_str = basepath * "config_east_heating.pdf"
PlotlyJS.savefig(char_east_plot,path_char_east_str)

