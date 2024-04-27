using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoteHit : MonoBehaviour
{
    public bool canBePressed;
    public KeyCode keyToPress;

    public GameObject hitEffect, goodEffect, perfectEffect, missedEffect;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(keyToPress))
        {
            if (canBePressed)
            {
                gameObject.SetActive(false);

                //GameMang.instance.hit();

                if(Mathf.Abs(transform.position.y) > 0.25){
                    Debug.Log("Hit");
                    GameMang.instance.normalHit();
                    Instantiate(hitEffect, transform.position, hitEffect.transform.rotation);
                }else if(Mathf.Abs(transform.position.y) > 0.05f){
                    Debug.Log("Good!");
                    GameMang.instance.goodHit();
                    Instantiate(goodEffect, transform.position, goodEffect.transform.rotation);

                }else {
                    Debug.Log("Perfect!");
                    GameMang.instance.perfectHit();
                    Instantiate(perfectEffect, transform.position, perfectEffect.transform.rotation);
                }
            }
        }

    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (other.tag == "Activator")
        {
            canBePressed = true;
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (gameObject.activeInHierarchy)
        {
            if (collision.tag == "Activator")
            {
                canBePressed = false;

                GameMang.instance.missed();
                Instantiate(missedEffect, transform.position, missedEffect.transform.rotation);
            }
        }
    }
}
