using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VertexColoring : MonoBehaviour {

	// Reference: 
	//		https://docs.unity3d.com/ScriptReference/Mesh-colors.html
	// Use this for initialization
	void Start () {
		Mesh mesh = GetComponent<MeshFilter>().mesh;
		Vector3[] vertices = mesh.vertices;

		Debug.Log("vertices count: " + vertices.Length);

		// create new colors array where the colors will be created.
		Color[] colors = new Color[vertices.Length];

		Color[] pixelColors = {Color.red, Color.green, Color.blue, Color.cyan, Color.grey, Color.yellow};

		for (int i = 0; i < vertices.Length; i++) {
			colors[i] = pixelColors[i % pixelColors.Length];
				//Color.Lerp(Color.red, Color.green, vertices[i].y);
		}

		// assign the array of colors to the Mesh.
		mesh.colors = colors;
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
