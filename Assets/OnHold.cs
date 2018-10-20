using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class OnHold : MonoBehaviour {

    public Text text;

    public void OnHoldOBJ ()
    {
        text.text = "basketball-sized iron-nickel meteorite found on Mars by the Mars rover Opportunity in January 2005";
    }

    public void OnReleaseOBJ()
    {
        text.text = "Heat Shield Rock";
    }
}
