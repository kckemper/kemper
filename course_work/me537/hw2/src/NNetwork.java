
public class NNetwork {

	private float []	inputs		= null;
	private float []	hiddens		= null;
	private float []	outputs		= null;
	private NNnode []	nodeHidden;
	private NNnode []	nodeOutput;
	private int nInputs;
	
	// constructor
	NNetwork (int nInputs, int nHidden, int nOutputs) {
		int i;
		
		this.nInputs = nInputs;
		this.nodeHidden = new NNnode[nHidden];			// create hidden layer array
		this.nodeOutput = new NNnode[nOutputs];			// create output layer array
		
		for (i=0;i<this.nodeHidden.length;i++) {		// construct each hidden node
			this.nodeHidden[i] = new NNnode(nInputs);
		}
		
		for (i=0;i<this.nodeOutput.length;i++) {		// construct each output node
			this.nodeOutput[i] = new NNnode(nHidden);
		}
		
	}
	
	// public
	public float[] run (float[] inputs) {
		int i;
		float[] hidden	= new float[nodeHidden.length];
		float[] out		= new float[nodeOutput.length];
		
		for (i=0;i<nodeHidden.length;i++) {				// evaluate the hidden layer...
			hidden[i] = nodeHidden[i].eval(inputs);
		}
		
		for (i=0;i<nodeOutput.length;i++) {				// evaluate the output layer...
			out[i] = nodeOutput[i].eval(hidden);
		}
		
		this.inputs		= inputs;
		this.hiddens	= hidden;
		this.outputs	= out;
		return out;
	}
	
	public float[] getWeightsHidden(int index) {
		return nodeHidden[index].getWeights();
	}
	
	public void setWeightsHidden(int index, float[] w) {
		nodeHidden[index].setWeights(w);
	}

	public float[] getWeightsOutputs(int index) {
		return nodeOutput[index].getWeights();
	}
	
	public void setWeightsOutputs(int index, float[] w) {
		nodeOutput[index].setWeights(w);
	}
	
	public int getNHidden() {
		return nodeHidden.length;
	}

	public int getNOutput() {
		return nodeOutput.length;
	}
	
	public int getNInputs() {
		return nInputs;
	}
	
	public float[] getInputs(){
		return this.inputs;
	}
	
	public float[] getHiddens(){
		return this.hiddens;
	}
	
	public float[] getOutputs(){
		return this.outputs;
	}
	
	// private
	
	
	
}
