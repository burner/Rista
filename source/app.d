import ggplotd.ggplotd; 
import ggplotd.aes; 
import ggplotd.geom;

void main()
{
	import std.stdio : writefln;
    import std.array : array;
    import std.conv : roundTo;
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

	foreach(it; 0 .. 4000000) {
		double v = rNorm(0, 1, rnd);
		minV = min(minV, v);
		maxV = max(maxV, v);
		//writefln("%7.4f", v);

		v *= count.length/fit;
		int idx = roundTo!(int)(v);
		idx += count.length/2;
		if(idx > 0 && idx < count.length) {
			count[idx]++;
		}
	}

	//auto countV = count.map!(a => a / cast(double)(count.length)).array;
	auto countV = count.map!(a => a / 1.0).array;

	writefln("%7.4f %7.4f %s %s", minV, maxV, countV, count.length);
	double[] y = iota(minV,maxV,(maxV-minV)/count.length).array;
	writefln("%s", y.length);

    auto aes = Aes!(typeof(y), "x", typeof(countV), "y")(y,countV);
	auto gg = GGPlotD().put( geomPoint( aes ) );
	gg.save( "hist.png" , 2048, 2048);
}
