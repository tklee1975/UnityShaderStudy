using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DynamicMaterial : MonoBehaviour {
	private Material mMaterial;
	/// <summary>
	/// Awake is called when the script instance is being loaded.
	/// </summary>
	void Awake()
	{
		Renderer renderer = GetComponent<Renderer>();
		if(renderer != null) {
			mMaterial = renderer.material;
		}
	}	
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		if(mMaterial != null) {
			Vector4 v = transform.localEulerAngles / 360;
			//v = Mathf.Clamp()
			mMaterial.SetVector("_ColorTint", v);
		}
	}
}
