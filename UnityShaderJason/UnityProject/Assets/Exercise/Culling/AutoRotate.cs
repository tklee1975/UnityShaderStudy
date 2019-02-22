using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoRotate : MonoBehaviour {
	public float rotationSpeed = 10.0f;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		Quaternion q = transform.localRotation;

		Vector3 euler = q.eulerAngles;
		euler.y += rotationSpeed * Time.deltaTime;

		q.eulerAngles = euler;
		transform.localRotation = q;
	}
}
