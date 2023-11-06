using Random
function key(n)
    max_width = 31
    num_discs = 11 
    k = []
    c = map( i -> i + 1, Random.randperm(max_width)[begin:num_discs])
    for i in 1:num_discs push!(k, rand(0:n-1,c[i])) end
    k
end


function str(v)
    #out_alph = "abcdefghijklmnopqrstuvwxyz" * string('\u2586')    
    #out_alph = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" * string('\u25A0')
    out_alph = "0|23456789"
    join(map(i -> out_alph[i+1:i+1],v ))
end

rgb(r,g,b) =  "\e[38;2;$(r);$(g);$(b)m"
red() = rgb(255,0,0)
yellow() = rgb(255,255,0)
white() = rgb(255,255,255)
gray(h) = rgb(h,h,h)


function print_key(f)
    print(white(),"f = \n")
    for i in eachindex(f) 
        print(str(f[i]),"\n")
    end
end

function print_vec(v)
    print(str(v),"\n")
end

function stack(f)
    s = 0
    for i in eachindex(f) s += f[i][begin] end
    s
end

function twist!(f,a,n)
    for i in eachindex(f) f[i][1] = mod(f[i][1] + a,n) end
end

function roll!(f)
    for i in eachindex(f) f[i] = circshift(f[i],1) end
end


function encode(p,f,n)
    c = Int64[]
    for i in eachindex(p)
        push!(c, mod( stack(f) + p[i], n))
        twist!(f,c[i],n)
        roll!(f)  
    end
    c
end

function decode(c,f,n)
    p = Int64[]
    for i in eachindex(c)
        push!(p, mod( c[i] - stack(f), n))
        twist!(f,c[i],n)
        roll!(f)  
    end
    p
end
function spin!(f, k, n)
    p = deepcopy(f[k])
    for i in eachindex(p)
        twist!(f, stack(f) + p[i], n)
        roll!(f)  
    end
end

function encrypt(p,q,n)
    l = length(q)
    for i in 1:l
        f = deepcopy(q)
        spin!(f,i,n)
        p = encode(p,f,n)
        p = reverse(p)
    end
    p
end
function decrypt(c,q,n)
    l = length(q)
    for i in 1:l
        f = deepcopy(q)
        spin!(f,l + 1 - i,n)
        c = reverse(c)
        c = decode(c,f,n)
        
    end
    c
end



    

function demo(n)
    f = key(n)
    l = 32
    print_key(f)
    println()
    for i in 1:2
        p = rand(0:n-1,l)
        print(red())
        print_vec(p)
        c = encrypt(p,f,n)
        print(yellow())
        print_vec(c)
        d = decrypt(c,f,n)
#        print(gray(100))
#        print_vec(p .!= c)
        println()
        d = decrypt(c,f,n)
        if p != d print("\nERROR\n") end
    end
end
#
#function decode!(c,f,n)
#    p = Int64[]
#    for i in eachindex(c)
#        push!(p, ( 2*n + c[i]  - f[1][1] - f[2][1])%n )
#        swhich!(f)
#        f[1][1] = (f[1][1] + p[i])%n
#        f[2][1] = (f[2][1] + c[i])%n
#    end
#    p
#end
#

#
#function decrypt(c,q,n)
#    l = length(q)
#    for i in 1:l
#        f = deepcopy(q)
#        f[2] = circshift(f[2],i)
#        f[1] = circshift(f[1],l + 1 - i)
#        c = reverse(c)
#        c = decode!(c,f,n)
#    end
#    c
#end
#
#
#function demo(n)
#    l = 64
#    f = key(n,l)
#    print_key(f)
#    println()
#    for i in 1:10
#        p = rand(0:n-1,l)
#        print(red())
#        print_vec(p)
#        c = encrypt(p,f,n)
#        print(yellow())
#        print_vec(c)
#        println()
#        d = decrypt(c,f,n)
#        if p != d print("\nERROR\n") end
#    end
#end
#    
#
#






