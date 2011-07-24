import java.util.Random;


public class NNnode {

	private float [] w;
	
	NNnode (int nInputs) {
		Random rand = new Random();
		int i;
		
		w = new float[nInputs+1];
		
		w[0] = (float) ((rand.nextFloat()*2-1)*(1/Math.sqrt(nInputs+1)));		// number between 0 and 0.1
		for (i=1;i<w.length;i++)
			w[i] = (float) ((rand.nextFloat()*2-1)*(1/Math.sqrt(nInputs+1)));
		
	}
	
	// public
	public float eval(float[] inputs) {
		int i;
		float sum=w[0];
		for (i=0;i<inputs.length;i++)
			sum += w[i+1]*inputs[i]; 
		return activate(sum);
	}
	
	public void setWeights (float [] w) {
		this.w = w;
	}
	
	public float[] getWeights () {
		return w;
	}
	
	
	// private
	private float activate(float sum) {
		return (float) (1/(1+Math.exp(-sum)));
//		if (sum <= 0)
//			return 0;
//		else
//			return 1;
	}
}
