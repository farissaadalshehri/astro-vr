using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerDoor : MonoBehaviour {

    public Animator anim;

    public void openDoor ()
    {
        anim.SetTrigger("open");
    }
}
