using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoadScene : MonoBehaviour {
    //pro
    public string sceneName;

    public void Load ()
    {
        UnityEngine.SceneManagement.SceneManager.LoadScene(sceneName);
    }
}
