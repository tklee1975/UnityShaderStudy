using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class RadialEnergyBar : MonoBehaviour {

	public float speed = 0.5f;

	private float _percent = 5;
	private Material _textMaterial; 
	private Text _text;

	// Use this for initialization
	void Start () {
		
		_text = gameObject.GetComponentInChildren<Text>();
		RawImage img = gameObject.GetComponentInChildren<RawImage>();
		if(img!=null) _textMaterial=img.material;

	}
	
	// Update is called once per frame
	void Update () {
	
		if(_text!=null){
			_text.text = Mathf.Round(_percent) + "%";
		}

		if(_textMaterial!=null){
			_textMaterial.SetFloat("_RadialBarPercent",-_percent/100);
		}
			
		_percent+=speed;

		if(_percent>=100) _percent=5;
	}
}
