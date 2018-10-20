using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BackToShip : MonoBehaviour {

    public Transform location;
    public GameObject menu;

	public void Teleport ()
    {
        menu.SetActive(true);
        transform.position = location.position;
        transform.rotation = location.rotation;
    }
}
