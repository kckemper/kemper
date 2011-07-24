import java.util.Random;


public class Slot {

	public int		id;
	private float	sigma2;
	private float	mu;
	
	// pdf coefficients
//	private float	pdf1;
//	private float	pdf2;
	
	Slot (int id, float mu, float sigma2) {

		this.id		= id;
//		this.pdf1	= (float)(1/Math.sqrt(2*Math.PI*sigma2));
//		this.pdf2	= (float)(2*sigma2);
		this.sigma2	= sigma2;
		this.mu		= mu;
//		System.out.printf("pdf1: %1.3f\n",pdf1);
//		System.out.printf("pdf2: %1.3f\n",pdf2);

	}

	public float pull() {
		Random rand = new Random();
		return (float)rand.nextGaussian()*sigma2+mu;
//		float tmp = rand.nextFloat()*100;
//		return (float)(pdf1*Math.exp(-(tmp-this.mu)*(tmp-this.mu)/this.pdf2 ) );
	}
	
}
