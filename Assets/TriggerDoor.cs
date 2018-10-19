using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerDoor : MonoBehaviour {

    public Animator anim;
    public float angle;
    bool opened = false;
    Valve.VR.InteractionSystem.CircularDrive reader;

    // Use this for initialization
    void Start ()
    {

        reader = gameObject.GetComponent<Valve.VR.InteractionSystem.CircularDrive>();
	}
	
	// Update is called once per frame
	void Update ()
    {

        if (opened)
            return;
        angle = reader.outAngle;

        if (angle > 270 )
        {
            anim.SetTrigger("open");
            opened = true;
        }
	}
}
