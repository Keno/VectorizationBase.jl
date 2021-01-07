
function sub_quote(W, @nospecialize(T), fast::Bool)
    vtyp = vtype(W, T)
    instrs = "%res = fneg $(fast_flags(fast)) $vtyp %0\nret $vtyp %res"
    quote
        $(Expr(:meta, :inline))
        Vec(llvmcall($instrs, _Vec{$W,$T}, Tuple{_Vec{$W,$T}}, data(v)))
    end
end

@generated vsub(v::Vec{W,T}) where {W, T <: Union{Float32,Float64}} = sub_quote(W, T, false)
@generated vsub_fast(v::Vec{W,T}) where {W, T <: Union{Float32,Float64}} = sub_quote(W, T, true)

@inline vsub(v::Vec{<:Any,<:NativeTypes}) = zero(v) - v

@inline vinv(v::Vec) = vfdiv(one(v), v)
@inline vinv(v::AbstractSIMD{W,<:Integer}) where {W} = inv(float(v))

@inline vabs(v::AbstractSIMD{W,<:Unsigned}) where {W} = v
@inline vabs(v::AbstractSIMD{W,<:Signed}) where {W} = ifelse(v > 0, v, -v)

@inline vround(v::AbstractSIMD{W,<:Integer}) where {W} = v
@inline vround(v::AbstractSIMD{W,<:Integer}, ::RoundingMode) where {W} = v

