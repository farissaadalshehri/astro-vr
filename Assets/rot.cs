using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class rot : MonoBehaviour {

    public float speed = 1;

	// Update is called once per frame
	void Update ()
    {
        transform.Rotate(Vector3.up, speed, Space.Self);
	}
}
