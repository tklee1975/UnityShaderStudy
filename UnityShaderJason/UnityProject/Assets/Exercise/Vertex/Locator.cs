using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Locator : MonoBehaviour {
	public Renderer renderer;

	// Use this for initialization
	void Start () {
		
	}

	/// <summary>
	/// Callback to draw gizmos that are pickable and always drawn.
	/// </summary>
	void OnDrawGizmos()
	{
		Gizmos.DrawCube(transform.position, Vector3.one * 0.2f);
	}
	
	// Update is called once per frame
	void Update () {
		if(renderer == null || renderer.material == null) {
			return;
		}

		var p = transform.position;
		var v = new Vector4(p.x, p.y, p.z, 1);
		//Debug.Log("updating targetMat: v=" + v);
		renderer.material.SetVector("_Locator", v);
	}
}
