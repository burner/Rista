import ggplotd.ggplotd; 
import ggplotd.aes; 
import ggplotd.geom;

void main()
{
	import std.stdio : writefln;
    import std.array : array;
    import std.algorithm.comparison : min, max;
    import std.math : sqrt;
    import std.algorithm : map;
    import std.range : repeat, iota;
    import std.random : uniform, Random;
	import dstats.random : rNorm;

	int[] count = new int[1000];

	auto rnd = Random(1337);
	double minV =  10000.0;
	double maxV = -10000.0;

	const fit = 6.0;

	foreach(it; 0 .. 500000) {
		double v = rNorm(0, 1, rnd);
		minV = min(minV, v);
		maxV = max(maxV, v);
		//writefln("%7.4f", v);

		v *= count.length/fit;
		int idx = cast(int)v;
		idx += count.length/2;
		if(idx > 0 && idx < count.length) {
			count[idx]++;
		}
	}

	auto countV = count.map!(a => a / cast(double)(count.length)).array;

	writefln("%7.4f %7.4f %s %s", minV, maxV, countV, count.length);
	int[] y = iota(0,cast(int)count.length,1).array;
	writefln("%s", y.length);

    auto aes = Aes!(typeof(y), "x", typeof(countV), "y")(y,countV);
	auto gg = GGPlotD().put( geomPoint( aes ) );
	//auto ys = (0.0).repeat( count.length ).array;
    //auto aesPs = aes.merge( Aes!(int[], "y", double[], "colour" )
    //    ( count, ys ) );

    //gg.put( geomPoint( aesPs ) );
	gg.save( "hist.png" );
        

    // Generate some noisy data with reducing width
    /*auto f = (double x) { return x/(1+x); };
    auto width = (double x) { return sqrt(0.1/(1+x)); };
    auto xs = iota( 0, 10, 0.1 ).array;

    auto ysfit = xs.map!((x) => f(x)).array;
    auto ysnoise = xs.map!((x) => f(x) + uniform(-width(x),width(x))).array;

    auto aes = Aes!(typeof(xs), "x",
        typeof(ysnoise), "y", string[], "colour" )( xs, ysnoise,
        ("a").repeat(xs.length).array ); 
        
    auto gg = GGPlotD().put( geomPoint( aes)); 
    gg.put(geomLine( Aes!(typeof(xs), "x", typeof(ysfit), "y" )( xs, ysfit)));

    //  
    auto ys2fit = xs.map!((x) => 1-f(x)).array;
    auto ys2noise = xs.map!((x) => 1-f(x) + uniform(-width(x),width(x))).array;

    gg.put( geomLine( Aes!(typeof(xs), "x", typeof(ys2fit), "y" )( xs,
        ys2fit)));

    gg.put( geomPoint( Aes!(typeof(xs), "x", typeof(ys2noise), "y", string[],
        "colour" )( xs, ys2noise, ("b").repeat(xs.length).array) ));

    gg.save( "noise.png" );
	*/
}
