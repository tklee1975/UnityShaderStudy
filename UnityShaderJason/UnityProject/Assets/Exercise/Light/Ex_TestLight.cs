using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Ex_TestLight : MonoBehaviour {

	// Update is called once per frame
	void Update () {
		Shader.SetGlobalVector("_GlobalLightPos", transform.position);
	}

	/// <summary>
	/// Callback to draw gizmos that are pickable and always drawn.
	/// </summary>
	void OnDrawGizmos()
	{
		Gizmos.DrawIcon(transform.position, "Light Gizmo.tiff", true);
	}
}
