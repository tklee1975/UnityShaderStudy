using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RadicalCircle : MonoBehaviour {


	// Color of the Circle
	[SerializeField]
	public Color color = Color.blue;

	// reference to the material 
	private Material mRadicalMaterial = null; 

	void Awake()
	{
		SpriteRenderer sprite = gameObject.GetComponentInChildren<SpriteRenderer>();
		if(sprite !=null) {
			mRadicalMaterial = sprite.material;
		} 

		UpdateColor();
	}

	void Start()
	{
		
	}

	// Percent of the Circle (0 - 100)
	private float mPercent = 0;
	public float Percent {
		get {
			return mPercent;
		}

		set {
			// value correction 
			mPercent = Mathf.Clamp(value, 0, 100);
			if(mRadicalMaterial != null) {
				mRadicalMaterial.SetFloat("_RadialBarPercent", -mPercent / 100);
			}
		}
	}

	
	public void UpdateColor() {
		if(mRadicalMaterial != null) {
		 	mRadicalMaterial.SetColor("_Color", color);
		}
	}

	// Update is called once per frame
	void Update () {
		
	}
}
